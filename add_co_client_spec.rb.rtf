{\rtf1\ansi\ansicpg1252\cocoartf2709
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red89\green138\blue67;\red24\green24\blue24;\red193\green193\blue193;
\red70\green137\blue204;\red194\green126\blue101;\red67\green192\blue160;\red212\green214\blue154;\red183\green111\blue179;
\red167\green197\blue152;}
{\*\expandedcolortbl;;\cssrgb\c41569\c60000\c33333;\cssrgb\c12157\c12157\c12157;\cssrgb\c80000\c80000\c80000;
\cssrgb\c33725\c61176\c83922;\cssrgb\c80784\c56863\c47059;\cssrgb\c30588\c78824\c69020;\cssrgb\c86275\c86275\c66667;\cssrgb\c77255\c52549\c75294;
\cssrgb\c70980\c80784\c65882;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs24 \cf2 \cb3 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 # frozen_string_literal: true\cf4 \cb1 \strokec4 \
\
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 require\cf4 \strokec4  \cf6 \strokec6 'spec_helper'\cf4 \cb1 \strokec4 \
\
\pard\pardeftab720\partightenfactor0
\cf7 \cb3 \strokec7 RSpec\cf4 \strokec4 .\cf8 \strokec8 feature\cf4 \strokec4  \cf6 \strokec6 'Add Co-Client Case'\cf4 \strokec4  \cf9 \strokec9 do\cf4 \cb1 \strokec4 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3   \cf8 \strokec8 let\cf4 \strokec4 (\cf5 \strokec5 :case_page\cf4 \strokec4 )               \{ \cf7 \strokec7 CasePage\cf4 \strokec4 .\cf5 \strokec5 new\cf4 \strokec4  \}\cb1 \
\cb3   \cf8 \strokec8 let\cf4 \strokec4 (\cf5 \strokec5 :co_client_case_page\cf4 \strokec4 )     \{ \cf7 \strokec7 CoClientCasePage\cf4 \strokec4 .\cf5 \strokec5 new\cf4 \strokec4  \}\cb1 \
\cb3   \cf8 \strokec8 let\cf4 \strokec4 (\cf5 \strokec5 :glue_api\cf4 \strokec4 )                \{ \cf7 \strokec7 GlueAPI\cf4 \strokec4 .\cf5 \strokec5 new\cf4 \strokec4  \}\cb1 \
\cb3   \cf8 \strokec8 let\cf4 \strokec4 (\cf5 \strokec5 :test_data\cf4 \strokec4 )               \{ glue_api.\cf8 \strokec8 create_data\cf4 \strokec4 (\cf6 \strokec6 'qa_program'\cf4 \strokec4 , \cf6 \strokec6 'pre_settlement_tradelines_ready_for_offer'\cf4 \strokec4 ) \}\cb1 \
\cb3   \cf8 \strokec8 let\cf4 \strokec4 (\cf5 \strokec5 :sfid\cf4 \strokec4 )                    \{ test_data[\cf6 \strokec6 'sfid'\cf4 \strokec4 ] \}\cb1 \
\
\cb3   scenario \cf6 \strokec6 'Add Co-Client case Happy Path E2E'\cf4 \strokec4  \cf9 \strokec9 do\cf4 \cb1 \strokec4 \
\cb3     \cf8 \strokec8 navigate_to_program_by_sfid\cf4 \strokec4 (sfid, \cf5 \strokec5 app:\cf4 \strokec4  \cf6 \strokec6 'CX360'\cf4 \strokec4 , \cf5 \strokec5 login_as:\cf4 \strokec4  \cf6 \strokec6 'servicecloud'\cf4 \strokec4 )\cb1 \
\cb3     \cf8 \strokec8 create_case\cf4 \strokec4 (\cf5 \strokec5 type:\cf4 \strokec4  \cf6 \strokec6 'Add Co-Client'\cf4 \strokec4 , \cf5 \strokec5 related_contact:\cf4 \strokec4  \cf5 \strokec5 :first\cf4 \strokec4 )\cb1 \
\cb3     wait_for_salesforce_page_load\cb1 \
\
\cb3     co_client_case_page.\cf8 \strokec8 fill_out_co_client_form\cf4 \cb1 \strokec4 \
\cb3     co_client_case_page.\cf8 \strokec8 create_co_client_button\cf4 \strokec4 .\cf8 \strokec8 click\cf4 \cb1 \strokec4 \
\cb3     \cf8 \strokec8 wait_for_popup\cf4 \strokec4 (\cf6 \strokec6 'Co-Client is created succesfully'\cf4 \strokec4 )\cb1 \
\cb3     co_client_case_page.\cf8 \strokec8 next_section_button\cf4 \strokec4 .\cf8 \strokec8 click\cf4 \cb1 \strokec4 \
\cb3     co_client_case_page.\cf8 \strokec8 generate_ea_button\cf4 \strokec4 .\cf8 \strokec8 click\cf4 \cb1 \strokec4 \
\cb3     wait_for_salesforce_page_load\cb1 \
\cb3     \cf8 \strokec8 sleep\cf4 \strokec4  \cf10 \strokec10 1\cf4 \strokec4  \cf2 \strokec2 # Sometimes click happens before page is loaded\cf4 \cb1 \strokec4 \
\cb3     co_client_case_page.\cf8 \strokec8 clear_error_modal_button\cf4 \strokec4 .\cf8 \strokec8 click\cf4 \strokec4  \cf9 \strokec9 if\cf4 \strokec4  co_client_case_page.\cf8 \strokec8 clear_error_modal_button\cf4 \strokec4 .\cf8 \strokec8 visible?\cf4 \cb1 \strokec4 \
\cb3     co_client_case_page.\cf8 \strokec8 send_ea_button\cf4 \strokec4 .\cf8 \strokec8 click\cf4 \cb1 \strokec4 \
\cb3     \cf8 \strokec8 wait_for_popup\cf4 \strokec4 (\cf6 \strokec6 'The EA has been sent successfully.'\cf4 \strokec4 )\cb1 \
\cb3     co_client_case_page.\cf8 \strokec8 next_section_button\cf4 \strokec4 .\cf8 \strokec8 click\cf4 \cb1 \strokec4 \
\cb3     \cf8 \strokec8 sleep\cf4 \strokec4  \cf10 \strokec10 2\cf4 \strokec4  \cf2 \strokec2 # Sometimes click happens before page is loaded\cf4 \cb1 \strokec4 \
\cb3     co_client_case_page.\cf8 \strokec8 close_case\cf4 \strokec4 (\cf5 \strokec5 case_status:\cf4 \strokec4  \cf6 \strokec6 'Complete'\cf4 \strokec4 )\cb1 \
\cb3     \cf8 \strokec8 wait_for_popup\cf4 \strokec4 (\cf6 \strokec6 'Case closed successfully'\cf4 \strokec4 )\cb1 \
\
\cb3     \cf8 \strokec8 expect\cf4 \strokec4 (co_client_case_page.\cf8 \strokec8 case_status_complete\cf4 \strokec4 ).\cf8 \strokec8 to\cf4 \strokec4  be_visible\cb1 \
\cb3   \cf9 \strokec9 end\cf4 \cb1 \strokec4 \
\pard\pardeftab720\partightenfactor0
\cf9 \cb3 \strokec9 end\cf4 \cb1 \strokec4 \
}