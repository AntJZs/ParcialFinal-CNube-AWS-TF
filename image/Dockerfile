FROM httpd:latest

# Install curl to query the ECS metadata endpoint
RUN apt-get update && apt-get install -y curl jq && rm -rf /var/lib/apt/lists/*

# Copy the custom entrypoint script and make it executable
COPY startup.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Run the script before starting Apache
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
