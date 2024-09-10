package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/go-sql-driver/mysql" // MySQL driver for Go
	"github.com/joho/godotenv"
)

func main() {
	// Load environment variables from `.env` file if it exists
	err := godotenv.Load()
	if err != nil {
		log.Println("No .env file found or failed to load, proceeding with system env variables.")
	}

	// AWS RDS Connection parameters
	rdsHost := os.Getenv("RDS_HOST")
	rdsPort := os.Getenv("RDS_PORT")
	rdsUser := os.Getenv("RDS_USER")
	rdsPass := os.Getenv("RDS_PASSWORD")
	rdsDB := os.Getenv("RDS_DB")

	// AWS Aurora Serverless Connection parameters
	auroraHost := os.Getenv("AURORA_HOST")
	auroraPort := os.Getenv("AURORA_PORT")
	auroraUser := os.Getenv("AURORA_USER")
	auroraPass := os.Getenv("AURORA_PASSWORD")
	auroraDB := os.Getenv("AURORA_DB")

	// Validate environment variables
	if rdsHost == "" || rdsPort == "" || rdsUser == "" || rdsPass == "" || rdsDB == "" {
		log.Fatalf("Missing AWS RDS environment variables")
	}

	if auroraHost == "" || auroraPort == "" || auroraUser == "" || auroraPass == "" || auroraDB == "" {
		log.Fatalf("Missing AWS Aurora Serverless environment variables")
	}

	// Connecting to RDS
	rdsDSN := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", rdsUser, rdsPass, rdsHost, rdsPort, rdsDB)
	rdsDBConn, err := sql.Open("mysql", rdsDSN)
	if err != nil {
		log.Fatalf("Failed to connect to AWS RDS: %v", err)
	}
	defer rdsDBConn.Close()

	// Connecting to Aurora Serverless
	auroraDSN := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", auroraUser, auroraPass, auroraHost, auroraPort, auroraDB)
	auroraDBConn, err := sql.Open("mysql", auroraDSN)
	if err != nil {
		log.Fatalf("Failed to connect to AWS Aurora Serverless: %v", err)
	}
	defer auroraDBConn.Close()

	// Test query to check connection for RDS
	fmt.Println("Running query on AWS RDS...")
	if err := runSampleQuery(rdsDBConn); err != nil {
		log.Fatalf("Query failed on AWS RDS: %v", err)
	}

	// Test query to check connection for Aurora Serverless
	fmt.Println("Running query on AWS Aurora Serverless...")
	if err := runSampleQuery(auroraDBConn); err != nil {
		log.Fatalf("Query failed on AWS Aurora Serverless: %v", err)
	}
}

// Sample function to run a query (e.g., SELECT, INSERT, etc.)
func runSampleQuery(db *sql.DB) error {
	// Example query: create table and insert data
	query := `
		CREATE TABLE IF NOT EXISTS test_table (
			id INT AUTO_INCREMENT,
			name VARCHAR(255) NOT NULL,
			PRIMARY KEY (id)
		);
		INSERT INTO test_table (name) VALUES ('sample data');
	`
	_, err := db.Exec(query)
	if err != nil {
		return fmt.Errorf("failed to execute query: %v", err)
	}

	// Example query to fetch data
	rows, err := db.Query("SELECT id, name FROM test_table")
	if err != nil {
		return fmt.Errorf("failed to run select query: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var id int
		var name string
		if err := rows.Scan(&id, &name); err != nil {
			return fmt.Errorf("failed to scan row: %v", err)
		}
		fmt.Printf("Row: ID=%d, Name=%s\n", id, name)
	}

	return nil
}
