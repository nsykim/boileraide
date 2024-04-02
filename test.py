import openai
from openai import OpenAI\
from dotenv import load_dotenv, dotenv_values

load_dotenv()


def create_chat_completion(prompt_messages):
    client = OpenAI()

    completion = client.chat.completions.create(
        model="gpt-4-turbo-preview",
        messages=prompt_messages
    )

    return completion.choices[0].message.content

def extract_tags_from_response(response):
    """
    Extracts tags from the AI response, assuming tags are prefixed with '#'
    and returns them as a set.
    """
    # Split the response by spaces and filter out words that start with '#'
    tags = {word.strip("#") for word in response.split() if word.startswith("#")}
    return tags

def main():
    prompt_messages = [
        {"role": "system", "content": "You are a helpful assistant with the design of helping the user come up with tags to search recipies for. Tags should look something like [15 minutes or less], or [occasion]. You should ask the users a few questions until you come up with about five tags"},
    ]

    print("What type of food are you feeling today? Type 'quit' to exit.")
    while True:
        user_input = input("You: ")
        if user_input.lower() == 'quit':
            print("Exiting chat...")
            break

        prompt_messages.append({"role": "user", "content": user_input})

        response_message = create_chat_completion(prompt_messages)
        print("AI:", response_message)

        prompt_messages.append({"role": "system", "content": response_message})

if __name__ == "__main__":
    main()