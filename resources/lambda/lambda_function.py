import boto3
from datetime import datetime, timedelta

def lambda_handler(event, context):
    ce = boto3.client('ce') # AWS Cost Explorer client
    s3 = boto3.client('s3') # S3 client
    bucket_name = 'dashboard-bucket-khalil-12345' # S3 bucket name
    html_key = 'index.html' # HTML file 

    end = datetime.utcnow().date() # Current date
    start = end - timedelta(days=7) # for One week ago

    response = ce.get_cost_and_usage(
        TimePeriod={
            'Start': start.strftime('%Y-%m-%d'),
            'End': end.strftime('%Y-%m-%d')
        },
        Granularity='DAILY', # changed from WEEKLY to DAILY because WEEKLY is not supported by Granularity. Only MONTHLY, DAILY AND HOURLY are supported.
        Metrics=['UnblendedCost']
        GroupBy=[{'Type': 'DIMENSION', 'Key': 'SERVICE'}]
    )# Fetches cost data from AWS Cost Explorer

    # Build HTML rows for each service
    rows = ''
    total = 0.0
    for group in response['ResultsByTime'][0]['Groups']:
        service = group['Keys'][0]
        amount = float(group['Metrics']['UnblendedCost']['Amount'])
        total += amount
        rows += f'<tr><td>{service}</td><td>${amount:.2f}</td></tr>'


    # HTML template (based on current index.html)
    html = f"""<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='UTF-8'>
    <title>Cloud Cost Dashboard</title>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <style>
        body {{ font-family: Arial, sans-serif; margin: 40px; background: #f9f9f9; }}
        h1 {{ color: #2c3e50; }}
        .container {{ background: #fff; padding: 24px; border-radius: 8px; box-shadow: 0 2px 8px #eee; }}
        table {{ width: 100%; border-collapse: collapse; margin-top: 24px; }}
        th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }}
        th {{ background: #f0f0f0; }}
    </style>
</head>
<body>
    <div class='container'>
        <h1>Cloud Cost Dashboard</h1>
        <p>AWS cost data for {start} to {end}:</p>
        <table>
            <tr><th>Service</th><th>Cost (USD)</th></tr>
            {rows}
            <tr><th>Total</th><th>${total:.2f}</th></tr>
        </table>
    </div>
</body>
</html>"""

    # Upload the HTML to S3
    s3.put_object(Bucket=bucket_name, Key=html_key, Body=html, ContentType='text/html')
    print(f"Uploaded cost dashboard to s3://{bucket_name}/{html_key}") # Logs the upload actionx
