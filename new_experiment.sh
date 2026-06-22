#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <experiment_name>"
  echo "  example: $0 random_walk"
  exit 1
fi

NAME="$1"
PACKAGE=$(echo "$NAME" | tr '-' '_')
DIR="experiments/$PACKAGE"
MAIN="main.odin"

if [[ -d "$DIR" ]]; then
  echo "error: $DIR already exists"
  exit 1
fi

# --- derive enum key and import alias from name ---
ENUM_KEY=$(echo "$PACKAGE" | tr '[:lower:]' '[:upper:]')
ALIAS=$(echo "$PACKAGE" | sed 's/_//g')

# --- create experiment package ---
mkdir -p "$DIR"
cat > "$DIR/$PACKAGE.odin" <<ODIN
package $PACKAGE

import exp "nature:experiments"
import rl "vendor:raylib"

Screen :: exp.Screen {
	init   = init,
	deinit = deinit,
	update = update,
}

init :: proc() {}

deinit :: proc() {}

update :: proc() -> exp.Transition {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.ClearBackground(rl.RAYWHITE)

	if rl.GuiLabelButton(rl.Rectangle{20, 20, 40, 40}, "back") do return .BACK

	return .NONE
}
ODIN

echo "created $DIR/$PACKAGE.odin"

# --- patch main.odin ---

# 1. add import line after the last existing experiment import
LAST_IMPORT=$(grep -n '^import.*"nature:experiments/' "$MAIN" | tail -1 | cut -d: -f1)
sed -i '' "${LAST_IMPORT}a\\
import $ALIAS \"nature:experiments/$PACKAGE\"
" "$MAIN"

# 2. add enum variant after the last existing one (before closing brace of SCREEN enum)
ENUM_CLOSE=$(awk '/^SCREEN :: enum \{/,/^\}/' "$MAIN" | grep -n '^\}' | head -1 | cut -d: -f1)
ENUM_BLOCK_START=$(grep -n '^SCREEN :: enum {' "$MAIN" | cut -d: -f1)
ENUM_INSERT=$(( ENUM_BLOCK_START + ENUM_CLOSE - 2 ))
sed -i '' "${ENUM_INSERT}a\\
	$ENUM_KEY,
" "$MAIN"

# 3. add screens map entry after the last existing one (before closing brace of screens literal)
SCREENS_CLOSE=$(awk '/^screens := \[SCREEN\]/,/^\}/' "$MAIN" | grep -n '^\}' | head -1 | cut -d: -f1)
SCREENS_BLOCK_START=$(grep -n '^screens := \[SCREEN\]' "$MAIN" | cut -d: -f1)
SCREENS_INSERT=$(( SCREENS_BLOCK_START + SCREENS_CLOSE - 2 ))
sed -i '' "${SCREENS_INSERT}a\\
	.$ENUM_KEY = $ALIAS.Screen,
" "$MAIN"

# 4. compute y position for the new button (last button y + 40)
LAST_BTN_Y=$(grep 'GuiLabelButton' "$MAIN" | grep -v 'flow_field\|back' | tail -1 | grep -o 'Rectangle{[^}]*}' | grep -o ', [0-9]*,' | head -1 | tr -d ', ')
NEW_Y=$(( LAST_BTN_Y + 40 ))

# 5. add button in main_menu_render before EndDrawing
ENDDRAW_LINE=$(grep -n 'rl.EndDrawing()' "$MAIN" | head -1 | cut -d: -f1)
BTN_INSERT=$(( ENDDRAW_LINE - 1 ))
LABEL=$(echo "$PACKAGE" | tr '_' ' ')
sed -i '' "${BTN_INSERT}a\\
	if rl.GuiLabelButton(rl.Rectangle{30, $NEW_Y, 100, 40}, \"$LABEL\") do screen = .$ENUM_KEY
" "$MAIN"

echo "patched $MAIN"
echo ""
echo "done — run 'just' to build"
