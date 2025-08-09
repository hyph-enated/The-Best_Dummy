FROM alpine:latest

# Install bash and any other dependencies
RUN apk add --no-cache bash jq

WORKDIR /app

# Copy your script
COPY final_algorithm.sh .

# Make it executable
RUN chmod +x final_algorithm.sh

# Run it using bash
CMD ["bash", "./final_algorithm.sh"]
