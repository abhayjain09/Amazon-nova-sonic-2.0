import os

value = os.environ.get("AWS_ACCESS_KEY_ID")
print(os.environ.get("AWS_SESSION_TOKEN"))
print(value)