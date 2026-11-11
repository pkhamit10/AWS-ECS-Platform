import os 
from flask import Flask, jsonify 
 
app = Flask(__name__) 
 
@app.get('/') 
def index(): 
    return jsonify( 
        application='clariness-ecs-demo', 
        version=os.getenv('APP_VERSION', 'local'), 
        environment=os.getenv('ENVIRONMENT', 'local') 
    ), 200 
 
@app.get('/health') 
def health(): 
    # Liveness: only proves that the application process responds. 
    return jsonify(status='healthy'), 200 
 
@app.get('/ready') 
def ready(): 
    # Day 1 placeholder. Replace with a database query on Day 2. 
    return jsonify(status='ready', database='not-configured'), 200 
 
if __name__ == '__main__': 
    app.run(host='0.0.0.0', port=5000) 
