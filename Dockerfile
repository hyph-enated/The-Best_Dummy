FROM alpine:latest

RUN apk add --no-cache bash jq

WORKDIR /app

COPY final_algorithm.sh .

RUN chmod +x final_algorithm.sh

ENTRYPOINT ["./final_algorithm.sh"]
