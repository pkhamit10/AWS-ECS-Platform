from app.main import app 
 
def test_health(): 
    client = app.test_client() 
    response = client.get('/health') 
    assert response.status_code == 200 
    assert response.get_json()['status'] == 'healthy' 

def test_index():
     client = app.test_client()
 
     response = client.get("/")
 
     assert response.status_code == 200
 
     data = response.get_json()
 
     assert data["application"] == "clariness-ecs-demo"

def test_ready():
    client = app.test_client()
 
    response = client.get("/ready")
 
    assert response.status_code == 200
 
    data = response.get_json()
 
    assert data["status"] == "ready"
    assert data["database"] == "not-configured"