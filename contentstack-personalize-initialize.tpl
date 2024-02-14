___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Contentstack Personalize Initialize",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "This tag template initializes the Contentstack Personalize SDK",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "projectUid",
    "displayName": "projectUid",
    "simpleValueType": true,
    "defaultValue": "6597ecc2addd0ce291323f5f"
  },
  {
    "type": "TEXT",
    "name": "personalizationSdkURL",
    "displayName": "personalizationSdkUrl",
    "simpleValueType": true,
    "defaultValue": "https://assets.contentstack.io/v3/assets/bltcd4841bc7e61a34b/blt5deecd1f5f9400db/65bb95ec24ea497124de729b/personalization.min.js"
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const log = require('logToConsole');
const callInWindow = require('callInWindow');
const injectScript = require('injectScript');

const personalizationURL = data.personalizationSdkURL;
const projectUid = data.projectUid;

const gtmOnFailure = () => {
  data.gtmOnFailure();
};

const gtmOnSuccess = () => {
  data.gtmOnSuccess();
};

const initializePersonalization = () => {
  const options = {edgeMode: true};

  callInWindow('personalization.init', projectUid, options );
  
  gtmOnSuccess();
};

const checkFieldsAndInjectScript = () => {
  if(!personalizationURL){
    log('personalizationSdkURL is missing');
    gtmOnFailure();
    return;
  }
  
  if(!projectUid){
    log('projectUid is missing');
    gtmOnFailure();
    return;
  }
  
  injectScript(personalizationURL, initializePersonalization, gtmOnFailure, personalizationURL);
};

checkFieldsAndInjectScript();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://assets.contentstack.io/v3/assets/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "personalization.init"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "personalization.isInitialized"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "personalization.getVariants"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "personalization.getUserId"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "dataLayer"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "personalization"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: tag fails if the personalizationSdkURL is not provided
  code: |-
    mockData.personalizationSdkURL = undefined;
    // Call runCode to run the template's code.
    runCode(mockData);

    // Verify that the tag finished successfully.
    assertApi('gtmOnFailure').wasCalled();
    assertApi('gtmOnSuccess').wasNotCalled();
- name: tag fails if projectUid is not provided
  code: |-
    mockData.projectUid = undefined;

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();
    assertApi('gtmOnSuccess').wasNotCalled();
- name: sdk is injected successfully
  code: |-
    runCode(mockData);

    const personalizationSdkURL = mockData.personalizationSdkURL;

    assertApi('injectScript').wasCalledWith(personalizationSdkURL, success, failure, personalizationSdkURL);
    assertApi('gtmOnSuccess').wasCalled();
- name: sdk init is called
  code: |
    runCode(mockData);

    assertApi('callInWindow').wasCalledWith('personalization.init', mockData.projectUid ,options);
setup: |-
  const mockData = {
    projectUid: 'mockProjectUid',
    personalizationSdkURL: 'mockURL',
  };

  let success, failure;
  mock('injectScript', (url, onSuccess, onFailure) => {
    success = onSuccess;
    failure = onFailure;
    onSuccess();
  });

  const options = {};
  options.edgeMode = true;


___NOTES___

Created on 14/02/2024, 15:31:48


