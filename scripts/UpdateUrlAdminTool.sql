update tool_options_ext set value = 'https' || substr(value, INSTR(value,':',1,1)),
DATE_MODIFIED = sysdate, MODIFIED_BY = user
WHERE property = 'URL' and value like 'http:%' and TOOL_NAME='AdminTool';

commit;