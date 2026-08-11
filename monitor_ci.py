import time
import os
import subprocess
import json

def get_ci_status():
    github_token = os.environ.get("GITHUB_TOKEN")
    if not github_token:
        print("Error: GITHUB_TOKEN environment variable not set.")
        return None

    repo_owner = "abc1199281"
    repo_name = "DSP_lab"
    branch_name = "dev_python"

    url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/commits/{branch_name}/check-runs"
    command = [
        "curl",
        "-H", f"Authorization: token {github_token}",
        "-H", "Accept: application/vnd.github.v3+json",
        url
    ]
    
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=True)
        output = json.loads(result.stdout)
        return output
    except subprocess.CalledProcessError as e:
        print(f"Error calling GitHub API: {e}")
        print(f"Stdout: {e.stdout}")
        print(f"Stderr: {e.stderr}")
        return None
    except json.JSONDecodeError as e:
        print(f"Error decoding JSON from GitHub API response: {e}")
        print(f"Response: {result.stdout}")
        return None

def send_message_to_agent(message):
    # This part depends on how to send a message back to the main agent.
    # For OpenClaw, this would typically involve `sessions_send` or a system event mechanism.
    # For this script, we'll print to stdout, which can be picked up by the parent process/agent.
    print(f"AGENT_MESSAGE: {message}")

if __name__ == "__main__":
    print("Starting CI monitoring script...", flush=True)

    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime())}] Checking CI status...", flush=True)
    status_data = get_ci_status()

    if status_data and status_data.get("total_count", 0) > 0:
        check_run = status_data["check_runs"][0] # Assuming we care about the first check run
        current_sha = check_run.get("head_sha")

        status = check_run.get("status")
        conclusion = check_run.get("conclusion")
        
        message = f"CI Status for commit {current_sha[:7]}: "

        if status == "completed":
            if conclusion == "success":
                message += "✅ SUCCESS. Preparing for next conversion.\n"
                send_message_to_agent(message)
            elif conclusion == "failure":
                output_summary = check_run.get("output", {}).get("summary")
                output_text = check_run.get("output", {}).get("text")
                message += f"❌ FAILED.\nSummary: {output_summary or 'N/A'}\nText: {output_text or 'N/A'}"
                send_message_to_agent(message)
            else:
                message += f"🟠 COMPLETED with {conclusion}."
                send_message_to_agent(message)
        elif status == "in_progress":
            message += "🟡 IN PROGRESS."
            send_message_to_agent(message)
        elif status == "queued":
            message += "⚪ QUEUED."
            send_message_to_agent(message)
        else:
            message += f"⚫ UNKNOWN status: {status}."
            send_message_to_agent(message)
    else:
        # No check runs found, perhaps a new push just happened and checks haven't started
        print("No check runs found yet. Waiting for CI to start...", flush=True)
        send_message_to_agent("CI Status: No checks found yet. Waiting...")