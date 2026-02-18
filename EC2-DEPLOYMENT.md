# EC2 Deployment Instructions

## Prerequisites
1. EC2 instance running Amazon Linux 2023
2. IAM role attached to EC2 with permissions for:
   - Amazon Bedrock (Nova Sonic model access)
   - Amazon Bedrock Knowledge Bases (if using RAG)
   - AWS Lambda (if using Bedrock Agents)
   - AWS Location Services (if using MCP)
3. Security group allowing inbound traffic on ports 3025 and 8084

## Deployment Steps

1. Upload project to EC2:
   ```bash
   scp -r Amazon-nova-sonic-2.0 ec2-user@<ec2-ip>:/tmp/
   ```

2. SSH into EC2:
   ```bash
   ssh ec2-user@<ec2-ip>
   ```

3. Move project to target directory:
   ```bash
   sudo mkdir -p /home/svc-pcldint/nova-sonic
   sudo mv /tmp/Amazon-nova-sonic-2.0 /home/svc-pcldint/nova-sonic/amazon-nova-sonic-2.0
   ```

4. Create service user if not exists:
   ```bash
   sudo useradd -r -s /bin/bash svc-pcldint
   sudo chown -R svc-pcldint:svc-pcldint /home/svc-pcldint
   ```

5. Run deployment script:
   ```bash
   cd /home/svc-pcldint/nova-sonic/amazon-nova-sonic-2.0
   sudo chmod +x deploy-ec2.sh
   sudo ./deploy-ec2.sh
   ```

6. Make service manager executable:
   ```bash
   sudo chmod +x service-manager.sh
   ```

## Service Management

Start services:
```bash
./service-manager.sh start
```

Stop services:
```bash
./service-manager.sh stop
```

Restart services:
```bash
./service-manager.sh restart
```

Check status:
```bash
./service-manager.sh status
```

View logs:
```bash
./service-manager.sh logs websocket
./service-manager.sh logs react
```

## Access Application

Open browser and navigate to:
```
http://<ec2-private-ip>:3025
```

## Troubleshooting

1. Check if services are running:
   ```bash
   ./service-manager.sh status
   ```

2. View WebSocket logs:
   ```bash
   sudo journalctl -u nova-sonic-websocket.service -n 100
   ```

3. View React logs:
   ```bash
   sudo journalctl -u nova-sonic-react.service -n 100
   ```

4. Verify ports are listening:
   ```bash
   sudo netstat -tlnp | grep -E '3025|8084'
   ```

5. Test WebSocket connection:
   ```bash
   curl http://localhost:8084
   ```

6. Verify IAM role permissions:
   ```bash
   aws sts get-caller-identity
   aws bedrock list-foundation-models --region us-east-1
   ```

## Security Notes

- Application uses EC2 IAM role for AWS credentials (no keys needed)
- WebSocket server binds to 0.0.0.0 to accept connections from React app
- Ensure security group only allows traffic from trusted sources
- Consider using Application Load Balancer for production deployments
