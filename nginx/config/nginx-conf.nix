{ nginx
, writeText
}: writeText "nginx.conf" ''
  user nobody nobody;
  worker_processes 1;
  daemon off;
  error_log /dev/stdout info;
  pid /dev/null;
  events {
    worker_connections 1024;
  }
  http {
    access_log /dev/stdout;
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    include ${nginx}/conf/mime.types;
    default_type application/octet-stream;
    server {
      listen 80;
      index index.html;
      client_max_body_size 50m;
      root /app/public;
      location /_probes {
        default_type application/json;
        location = /_probes/readiness {
          return 200 '{"ready":true}';
        }
        location = /_probes/liveness {
          return 200 '{"live":true}';
        }
      }
    }
  }
''
