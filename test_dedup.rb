# Test if Nila deduplication is working

require File.expand_path('../config/environment', __FILE__)

puts "Nila version: #{Nila::VERSION}"
puts "Nila enabled: #{Nila.configuration.enabled}"
puts

# Check if extensions are loaded
puts "ActiveStorage::Blob ancestors:"
puts ActiveStorage::Blob.singleton_class.ancestors.first(10).inspect
puts

puts "ActiveStorage::Attached::One ancestors:"
puts ActiveStorage::Attached::One.ancestors.first(10).inspect
puts

# Create a test upload
puts "Creating first upload..."
upload1 = Upload.create!(name: "Test 1")
file = File.open(Rails.root.join("app/assets/images/.keep"), "rb")
upload1.file.attach(io: file, filename: "test.txt", content_type: "text/plain")
file.close

blob1_id = upload1.file.blob.id
puts "First blob ID: #{blob1_id}, checksum: #{upload1.file.blob.checksum}"
puts

# Create a second upload with the same file
puts "Creating second upload with same file..."
upload2 = Upload.create!(name: "Test 2")
file = File.open(Rails.root.join("app/assets/images/.keep"), "rb")
upload2.file.attach(io: file, filename: "test.txt", content_type: "text/plain")
file.close

blob2_id = upload2.file.blob.id
puts "Second blob ID: #{blob2_id}, checksum: #{upload2.file.blob.checksum}"
puts

if blob1_id == blob2_id
  puts "✓ SUCCESS: Deduplication is working! Both uploads share the same blob."
else
  puts "✗ FAIL: Deduplication is NOT working. Different blobs were created."
  puts "  Expected blob ID: #{blob1_id}"
  puts "  Got blob ID: #{blob2_id}"
end

# Cleanup
upload1.destroy
upload2.destroy
