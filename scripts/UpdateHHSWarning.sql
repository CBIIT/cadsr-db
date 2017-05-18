UPDATE SBREXT.TOOL_OPTIONS_EXT SET VALUE = '<ul style="text-align:left; padding:20px;" class="hhswarningMain"><li>
<span>This warning banner provides privacy and security notices consistent withss applicable federal laws, directives, and other federal guidance for 
accessing this Government system, which includes (1) this computer network, (2) all computers connected to this network, and (3) all devices and storage 
media attached to this network or to a computer on this network.</span></li><li><span>This system is provided for Government-authorized use only.</span></li>
<li><span>Unauthorized or improper use of this system is prohibited and may result in disciplinary action and/or civil and criminal penalties.</span></li>
<li><span>Personal use of social media and networking sites on this system is limited as to not interfere with official work duties and is subject to 
monitoring.</span></li><li><span>By using this system, you understand and consent to the following:</span><ul class="hhswarningSub"><li><span>The Government 
may monitor, record, and audit your system usage, including usage of personal devices and email systems for official duties or to conduct HHS business. 
Therefore, you have no reasonable expectation of privacy regarding any communication or data transiting or stored on this system. At any time, and 
for any lawful Government purpose, the government may monitor, intercept, and search and seize any communication or data transiting or stored on this 
system.</span></li><li><span>Any communication or data transiting or stored on this system may be disclosed or used for any lawful Government 
purpose.</span></li></ul></li></ul>' 
WHERE TOOL_NAME = 'caDSR' and PROPERTY='WARNING.BANNER'
/
commit
/