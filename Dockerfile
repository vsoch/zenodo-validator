FROM python:3.13-slim

RUN pip install --no-cache-dir check-jsonschema

# Copy the schema and entrypoint
COPY schema.json /schema.json
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
