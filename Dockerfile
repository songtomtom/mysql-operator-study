FROM golang:1.22.5

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /server

EXPOSE 8080

CMD [ "/server" ]