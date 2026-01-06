#!/bin/bash
set -e

# --- Fun Branding ---
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨  ZENODO METADATA VALIDATOR  ✨"
echo "🛰️  Preparing your research for the archives..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Paths
FILE_TO_VALIDATE="${GITHUB_WORKSPACE}/${INPUT_PATH}"
SCHEMA_PATH="${INPUT_SCHEMA_PATH}"

echo "🔍 Hunting for your metadata file at: $INPUT_PATH"

if [ ! -f "$FILE_TO_VALIDATE" ]; then
  echo "❌ ERROR: We looked everywhere, but couldn't find $INPUT_PATH!"
  echo "💡 Tip: Make sure the file exists in your repository root."
  exit 1
fi

echo "🔮 Summoning the JSON spirits to check your work..."
echo "📜 Using Schema: $SCHEMA_PATH"
echo "🎨 Output Format: $INPUT_ERROR_FORMAT"
echo ""

# Run check-jsonschema with the corrected flag: --output-format
if check-jsonschema --schemafile "$SCHEMA_PATH" "$FILE_TO_VALIDATE" --output-format "$INPUT_ERROR_FORMAT"; then
  echo ""
  echo "🥳 HOORAY! Your .zenodo.json is shiny and valid!"
  echo "🏆 You're a hero of Open Science! 🚀✨"
  exit 0
else
  echo ""
  echo "😱 OH SNAP! The validation failed!"
  echo "🌋 The JSON spirits are displeased. Please fix the errors above."
  echo "💔 Your metadata isn't ready for the archive yet!"
  exit 1
fi
