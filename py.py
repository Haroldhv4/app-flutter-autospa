import secrets

# Generate a unique key with 32 characters
unique_key = secrets.token_urlsafe(32)
print(unique_key)
