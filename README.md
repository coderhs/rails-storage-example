# Active Storage Test App

A Rails 8.1 application demonstrating Active Storage file uploads with Turbo Streams for real-time UI updates.

## Features

- File upload with Active Storage
- Real-time updates using Turbo Streams (no page refresh)
- Display of uploaded files with download links
- Visibility into Active Storage internals:
  - Attachments table (`active_storage_attachments`)
  - Blobs table (`active_storage_blobs`)

## Requirements

- Ruby 3.x
- Rails 8.1
- SQLite3

## Setup

```bash
# Install dependencies
bundle install

# Setup database
bin/rails db:create db:migrate

# Start the server
bin/rails server
```

Visit `http://localhost:3000` to use the application.

## Usage

1. Enter a name for your upload
2. Select a file
3. Click "Upload"

The file will be uploaded and all three tables will update instantly without page refresh:
- **Uploaded Files** - Your Upload records with file download links
- **Active Storage Attachments** - The join table linking records to blobs
- **Active Storage Blobs** - File metadata (filename, content type, size, checksum)

## Project Structure

- `app/models/upload.rb` - Upload model with `has_one_attached :file`
- `app/controllers/uploads_controller.rb` - Handles CRUD with Turbo Stream responses
- `app/views/uploads/` - Views and Turbo Stream templates
