Prevent Corruption of known-hosts file when bouncing between VMs reusing IPs

ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" user@x.x.x.x

UserKnownHostsFile=/dev/null option prevents the server host key from being recorded.

StrictHostKeyChecking=no option tells SSH not to verify the authenticity of the server host key.

This practice unsafe and lacks security in production environments. It's advised to only do this inside of isolated environments. 
