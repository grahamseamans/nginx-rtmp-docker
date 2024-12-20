
# Simple RTMP Streaming Server with Docker

This setup provides a straightforward way to get an RTMP streaming server running using Docker and nginx.

## Getting Started

### 1. Build the Docker Image

First, you need to build the Docker image for the RTMP server. Run the following command in the same directory as the `Dockerfile` and `nginx.config`:

```bash
docker build -t streaming-server .
```

### 2. Run the RTMP Server

Once the image is built, run the container with the necessary ports exposed:

```bash
docker run -d -p 80:80 -p 1935:1935 -p 8080:8080 --name streaming-server streaming-server
```

This will start the RTMP server, with the following ports:

- **80**: for HTTP
- **1935**: for RTMP streaming
- **8080**: for RTMP statistics (optional)

### 3. Testing the Setup

#### Push a Stream to the RTMP Server

You can use `ffmpeg` to push a stream to the RTMP server. For example, if you have an input file like `input.wav`:

```bash
ffmpeg -re -i input.wav -c copy -f flv rtmp://localhost:1935/live/stream
```

This works with other media formats as well, like `mp4`. Just replace `input.wav` with your preferred input file.

#### Play the Stream

You can play the live stream using `ffplay`:

```bash
ffplay rtmp://localhost:1935/live/stream
```

Alternatively, you can use any other RTMP-capable player to access the stream at the same URL.

---

## Notes

- **Ports**: Make sure that the ports (80, 1935, 8080) are available on your machine and not being used by other services.
- **Testing**: The configuration has been tested with WAV and MP4 files. Results with other formats may vary.
- **Customization**: You can adjust the NGINX configuration or `Dockerfile` to suit more specific needs, such as adding transcoding or different input formats.
