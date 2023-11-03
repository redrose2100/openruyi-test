#!/usr/bin/bash
echo -e -n "HTTP/1.0 200\r\n"
echo -e -n "Content-Type:text/html\r\n"
echo -e -n "\r\n"

echo "<html><body>"
echo "now is $(date)"
echo "</body></html>"