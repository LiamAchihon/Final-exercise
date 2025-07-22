# Step 1: Use a slim Python base image
FROM python:3.9-slim

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Step 4: Copy the Flask application code
COPY app.py .

# Step 5: Expose port 5000 for the Flask app
EXPOSE 5000

# Step 6: Run the Flask app
CMD ["python", "app.py"]

