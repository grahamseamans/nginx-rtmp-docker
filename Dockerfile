# # Use an official Nginx base image with the specific version
# FROM nginx:1.26.2

# # Install necessary packages for building NGINX and RTMP module
# RUN apt-get update && apt-get install -y \
#     build-essential \
#     libpcre3-dev \
#     zlib1g-dev \
#     libssl-dev \
#     wget \
#     ffmpeg \
#     && rm -rf /var/lib/apt/lists/*

# # Download NGINX source and the NGINX RTMP module
# RUN wget http://nginx.org/download/nginx-1.26.2.tar.gz && \
#     tar -zxvf nginx-1.26.2.tar.gz && \
#     wget https://github.com/arut/nginx-rtmp-module/archive/refs/tags/v1.2.1.tar.gz && \
#     tar -zxvf v1.2.1.tar.gz

# ENV CFLAGS="-Wno-error=implicit-fallthrough"

# # Compile NGINX with the RTMP module
# RUN cd nginx-1.26.2 && \
#     ./configure \
#     --add-module=../nginx-rtmp-module-1.2.1 \
#     && make && make install

# # Set the working directory to nginx home directory
# WORKDIR /usr/local/nginx

# # Copy custom NGINX config with RTMP support
# COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# # Expose ports for HTTP, RTMP
# EXPOSE 80 1935

# # Command to run nginx
# CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

# Use an official Nginx base image with the specific version
FROM nginx:1.26.2

# Install necessary packages for building NGINX and RTMP module
RUN apt-get update && apt-get install -y \
    build-essential \
    libpcre3-dev \
    zlib1g-dev \
    libssl-dev \
    wget \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Download NGINX source and the NGINX RTMP module
RUN wget http://nginx.org/download/nginx-1.26.2.tar.gz && \
    tar -zxvf nginx-1.26.2.tar.gz && \
    wget https://github.com/arut/nginx-rtmp-module/archive/refs/tags/v1.2.1.tar.gz && \
    tar -zxvf v1.2.1.tar.gz

ENV CFLAGS="-Wno-error=implicit-fallthrough"

# Compile NGINX with the RTMP module
RUN cd nginx-1.26.2 && \
    ./configure \
    --add-module=../nginx-rtmp-module-1.2.1 \
    && make && make install

# Create necessary directories for VOD, HLS, and DASH
RUN mkdir -p /var/flvs /var/mp4s /tmp/hls /tmp/dash

# Set the working directory to nginx home directory
WORKDIR /usr/local/nginx

# Copy custom NGINX config with RTMP support
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# Create a basic stat.xsl file for RTMP stats
RUN echo '<?xml version="1.0"?> \
    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"> \
    <xsl:template match="/"> \
    <html><body><h2>RTMP Stream Stats</h2> \
    <table border="1"> \
    <tr><th>Application</th><th>Stream</th></tr> \
    <xsl:for-each select="rtmp/server/application"> \
    <tr><td><xsl:value-of select="name"/></td> \
    <td><xsl:value-of select="live/stream/key"/></td></tr> \
    </xsl:for-each> \
    </table> \
    </body></html> \
    </xsl:template> \
    </xsl:stylesheet>' > /usr/local/nginx/html/stat.xsl

# Expose ports for HTTP, RTMP
EXPOSE 80 1935 8080

# Command to run nginx
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]