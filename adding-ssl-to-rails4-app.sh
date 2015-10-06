## For detailed instruction read the article here 
## http://blog.sudobits.com/2015/10/06/adding-ssl-to-a-rails-application/

## Generating CSR
openssl genrsa -out example.com.key 2048
openssl req -new -key example.com.key -out example.com.csr

### copy csr to clipboard (required during ssl order process)
xclip -sel clip < path_to_your_csr_directory/example.com.csr

### bundle the certs together
cat www_example_com.crt COMODORSADomainValidationSecureServerCA.crt COMODORSAAddTrustCA.crt AddTrustExternalCARoot.crt > ssl-bundle.crt

## Rails config
config.force_ssl = true

## Nginx config
sudo nano /etc/nginx/sites-available/example.com

### a sample config
https://gist.github.com/rkjha/057fd084e65651326ee8

sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/example.com
sudo service nginx reload
