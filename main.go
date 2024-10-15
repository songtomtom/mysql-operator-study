package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	// MySQL 연결 설정
	db, err := sql.Open(
		"mysql",
		"root:sakila@tcp(mysql-cluster-mysql-master.mysql-cluster.svc.cluster.local:3306)/mysql",
	)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// 연결 테스트
	err = db.Ping()
	if err != nil {
		log.Fatal(err)
	}

	http.HandleFunc(
		"/", func(w http.ResponseWriter, r *http.Request) {
			var version string
			err := db.QueryRow("SELECT VERSION()").Scan(&version)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			fmt.Fprintf(w, "Connected to MySQL version: %s", version)
		},
	)

	log.Println("Server starting on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
