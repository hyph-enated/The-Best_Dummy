FROM alpine:latest

RUN apk add --no-cache bash jq

WORKDIR /app

COPY team_scheduling.sh .

RUN chmod +x team_scheduling.sh

ENTRYPOINT ["/bin/bash"]

CMD ["./team_scheduling.sh"]
