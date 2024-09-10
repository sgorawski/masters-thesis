package main

import (
	"context"
	"crypto/rand"
	"fmt"
	"log"
	"os"
	"time"

	"cloud.google.com/go/storage"
	"google.golang.org/api/option"
)

const (
	bucketName      = "your-bucket-name"
	coldlineBucket  = "your-coldline-bucket"
	standardClass   = "STANDARD"
	coldlineClass   = "COLDLINE"
	credentialsFile = "path-to-your-service-account-file.json"
	fileSize        = 1024 * 1024 // 1MB random file
)

// Generates a random file with the specified size
func generateRandomFile(size int) ([]byte, error) {
	data := make([]byte, size)
	_, err := rand.Read(data)
	if err != nil {
		return nil, err
	}
	return data, nil
}

// Uploads the file to Google Cloud Storage
func uploadToGCS(ctx context.Context, client *storage.Client, bucketName, objectName string, fileData []byte, storageClass string) error {
	bucket := client.Bucket(bucketName)
	obj := bucket.Object(objectName)

	// Set storage class if required
	obj = obj.If(storage.Conditions{})
	w := obj.NewWriter(ctx)
	w.StorageClass = storageClass

	if _, err := w.Write(fileData); err != nil {
		return err
	}
	if err := w.Close(); err != nil {
		return err
	}
	fmt.Printf("Uploaded %s to %s (Storage class: %s)\n", objectName, bucketName, storageClass)
	return nil
}

func main() {
	ctx := context.Background()

	// Load credentials from file
	client, err := storage.NewClient(ctx, option.WithCredentialsFile(credentialsFile))
	if err != nil {
		log.Fatalf("Failed to create client: %v", err)
	}
	defer client.Close()

	// Generate random file
	fileData, err := generateRandomFile(fileSize)
	if err != nil {
		log.Fatalf("Failed to generate random file: %v", err)
	}

	// Ask user whether to split file or not
	var option string
	fmt.Println("Choose storage option: 1) Entirely in Standard, 2) Split between Standard and Coldline")
	fmt.Scan(&option)

	objectName := fmt.Sprintf("random-file-%d", time.Now().Unix())

	if option == "1" {
		// Store entire file in standard storage
		err = uploadToGCS(ctx, client, bucketName, objectName, fileData, standardClass)
		if err != nil {
			log.Fatalf("Failed to upload to standard storage: %v", err)
		}
	} else if option == "2" {
		// Split file between standard and coldline storage
		halfSize := len(fileData) / 2

		// First half to standard
		err = uploadToGCS(ctx, client, bucketName, objectName+"-part1", fileData[:halfSize], standardClass)
		if err != nil {
			log.Fatalf("Failed to upload first half to standard storage: %v", err)
		}

		// Second half to coldline
		err = uploadToGCS(ctx, client, coldlineBucket, objectName+"-part2", fileData[halfSize:], coldlineClass)
		if err != nil {
			log.Fatalf("Failed to upload second half to coldline storage: %v", err)
		}
	} else {
		fmt.Println("Invalid option selected.")
		os.Exit(1)
	}

	fmt.Println("Upload completed successfully.")
}
