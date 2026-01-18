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

# Handle allowed extra properties
FINAL_SCHEMA_PATH="$SCHEMA_PATH"
if [ -n "$INPUT_ALLOWED_EXTRA_PROPERTIES" ]; then
  echo "✨ Allowing extra properties: $INPUT_ALLOWED_EXTRA_PROPERTIES"
  FINAL_SCHEMA_PATH="/tmp/modified_schema.json"

  # Use Python to modify the schema and add allowed extra properties
  if ! SCHEMA_PATH_ESC="$SCHEMA_PATH" \
       FINAL_SCHEMA_PATH_ESC="$FINAL_SCHEMA_PATH" \
       ALLOWED_PROPS_ESC="$INPUT_ALLOWED_EXTRA_PROPERTIES" \
       python3 << 'PYTHON_EOF'
import json
import os
import sys

try:
    schema_path = os.environ['SCHEMA_PATH_ESC']
    final_schema_path = os.environ['FINAL_SCHEMA_PATH_ESC']
    allowed_props_str = os.environ['ALLOWED_PROPS_ESC']

    # Read the original schema
    with open(schema_path, 'r') as f:
        schema = json.load(f)

    # Ensure schema has the expected structure
    if not isinstance(schema, dict):
        print('❌ ERROR: Schema must be a JSON object', file=sys.stderr)
        sys.exit(1)

    # Parse comma-separated list of allowed properties
    allowed_props = [prop.strip() for prop in allowed_props_str.split(',') if prop.strip()]

    if not allowed_props:
        print('❌ ERROR: No valid property names found in allowed_extra_properties', file=sys.stderr)
        sys.exit(1)

    # Ensure properties object exists
    if 'properties' not in schema:
        schema['properties'] = {}

    # Add each allowed property to the schema's properties object
    # Use empty schema {} which allows any type
    for prop in allowed_props:
        if prop not in schema['properties']:
            schema['properties'][prop] = {}

    # Write the modified schema
    with open(final_schema_path, 'w') as f:
        json.dump(schema, f, indent=2)

    print(f'✅ Modified schema written to {final_schema_path}')
except KeyError as e:
    print(f'❌ ERROR: Missing environment variable: {e}', file=sys.stderr)
    sys.exit(1)
except FileNotFoundError:
    print(f'❌ ERROR: Schema file not found: {schema_path}', file=sys.stderr)
    sys.exit(1)
except json.JSONDecodeError as e:
    print(f'❌ ERROR: Invalid JSON in schema file: {e}', file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f'❌ ERROR: Failed to modify schema: {e}', file=sys.stderr)
    sys.exit(1)
PYTHON_EOF
  then
    echo "❌ Failed to modify schema for extra properties"
    exit 1
  fi
fi

echo ""

# Run check-jsonschema with the corrected flag: --output-format
if check-jsonschema --schemafile "$FINAL_SCHEMA_PATH" "$FILE_TO_VALIDATE" --output-format "$INPUT_ERROR_FORMAT"; then
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
