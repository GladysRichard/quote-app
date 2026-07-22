# Step 1: Use lightweight Nginx web server
FROM nginx:alpine

# Step 2: Copy your website into Nginx's default public folder
COPY index.html /usr/share/nginx/html/index.html

# Step 3: Expose port 80 for web traffic
EXPOSE 80