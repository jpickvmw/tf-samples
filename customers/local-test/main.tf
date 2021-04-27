resource "null_resource" "download-file" {
  provisioner "local-exec" {
    command = <<EOT
    apk --no-cache add curl
    EOT
  }
}

resource "null_resource" "test-local" {
  provisioner "local-exec" {
    command = <<EOT
    curl -Is https://www.google.de | head -n 1
    EOT
  } 
  depends_on = [null_resource.download-file]
}
