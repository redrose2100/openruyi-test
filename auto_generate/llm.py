import re
import json
from langchain_openai import ChatOpenAI
from langchain_core.messages import ChatMessage
from config import config
from prompt import GENERATE_SCRIPT_SYS_PROMPT, GENERATE_SCRIPT_USER_PROMPT, CHECK_PACKAGE_SYS_PROMPT, CHECK_PACKAGE_USER_PROMPT
MAX_TIMEOUT = 60
MAX_TOKENS = 8192


def get_llm():
    llm = ChatOpenAI(
        openai_api_key=config["LLM_KEY"],
        openai_api_base=config["LLM_URL"],
        model_name=config["LLM_MODEL_NAME"],
        tiktoken_model_name="cl100k_base",
        max_tokens=MAX_TOKENS,
        streaming=True,
        temperature=0.1,
        request_timeout=MAX_TIMEOUT,
    )
    return llm


def get_chat_message(role, content):
    return ChatMessage(role=role, content=content)


def generate_script(package_info, command_info, note):
    llm = get_llm()
    messages = [get_chat_message("system", GENERATE_SCRIPT_SYS_PROMPT), get_chat_message(
        "user", GENERATE_SCRIPT_USER_PROMPT.format(package_info=package_info, command_info=command_info, note=note)), ]
    result = llm.invoke(messages).content
    matches = re.findall(r"```shell(.*?)```", result, re.DOTALL)
    return matches[0]


def check_package_command(package_info):
    llm = get_llm()
    messages = [
        get_chat_message("system", CHECK_PACKAGE_SYS_PROMPT),
        get_chat_message("user", CHECK_PACKAGE_USER_PROMPT.format(package_info=package_info)),
    ]
    result = llm.invoke(messages).content
    matches = re.findall(r"```json(.*?)```", result, re.DOTALL)
    if matches:
        result_json = json.loads(matches[0])
        return result_json['command']
    else:
        return None
