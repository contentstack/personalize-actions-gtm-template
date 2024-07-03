﻿___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Contentstack Personalize Actions",
  "categories": [
    "MARKETING",
    "ANALYTICS",
    "PERSONALIZATION"
  ],
  "brand": {
    "id": "contentstack",
    "displayName": "Contentstack"
  },
  "description": "Integrate the Personalize SDK into your frontend seamlessly through Google Tag Manager",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "actionType",
    "displayName": "Action Type",
    "selectItems": [
      {
        "value": "triggerImpressions",
        "displayValue": "Trigger Impressions"
      },
      {
        "value": "triggerEvent",
        "displayValue": "Trigger Event"
      },
      {
        "value": "setAttributes",
        "displayValue": "Set Attributes"
      },
      {
        "value": "initialize",
        "displayValue": "Initialize"
      },
      {
        "value": "setUserId",
        "displayValue": "Set UserId"
      },
      {
        "value": "reset",
        "displayValue": "Reset"
      }
    ],
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "eventKey",
    "displayName": "Event Key",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "actionType",
        "paramValue": "triggerEvent",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "Custom event key defined in the Personalize management console"
  },
  {
    "type": "PARAM_TABLE",
    "name": "experiences",
    "displayName": "Experiences",
    "paramTableColumns": [
      {
        "param": {
          "type": "TEXT",
          "name": "shortUID",
          "displayName": "ShortUID",
          "simpleValueType": true
        },
        "isUnique": true
      }
    ],
    "enablingConditions": [
      {
        "paramName": "actionType",
        "paramValue": "triggerImpressions",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "Short UIDs of the experiences for which you want to register an impression"
  },
  {
    "type": "PARAM_TABLE",
    "name": "userAttributes",
    "displayName": "Attributes",
    "paramTableColumns": [
      {
        "param": {
          "type": "TEXT",
          "name": "attributeKey",
          "displayName": "Key",
          "simpleValueType": true
        },
        "isUnique": true
      },
      {
        "param": {
          "type": "TEXT",
          "name": "attributeValue",
          "displayName": "Value",
          "simpleValueType": true
        },
        "isUnique": false
      }
    ],
    "enablingConditions": [
      {
        "paramName": "actionType",
        "paramValue": "setAttributes",
        "type": "EQUALS"
      }
    ],
    "help": "These attributes are used to evaluate audience membership"
  },
  {
    "type": "TEXT",
    "name": "projectUid",
    "displayName": "Project UID",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "actionType",
        "paramValue": "initialize",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY",
        "enablingConditions": []
      }
    ],
    "help": "The UID of your project"
  },
  {
    "type": "TEXT",
    "name": "personalizeSdkUrl",
    "displayName": "Personalize SDK URL",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "actionType",
        "paramValue": "initialize",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "defaultValue": "https://assets.contentstack.io/v3/assets/bltcd4841bc7e61a34b/blt02415cd3d24cb58b/65cef205971dbb1f453ff24d/personalization.min.js"
  },
  {
    "type": "CHECKBOX",
    "name": "preserveUserAttributes",
    "checkboxText": "Preserve User Attributes",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "actionType",
        "paramValue": "setUserId",
        "type": "EQUALS"
      }
    ],
    "help": "Set this to true if you want the attributes to be preserved/merged when the user logs in"
  },
  {
    "type": "TEXT",
    "name": "edgeApiUrl",
    "displayName": "Edge API URL",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "actionType",
        "paramValue": "initialize",
        "type": "EQUALS"
      }
    ],
    "help": "Choose between different regions by setting the Edge API URL. You don\u0027t need to change this field if your project is created in AWS NA region. See https://www.contentstack.com/docs/developers/contentstack-regions/about-regions for more information.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "defaultValue": "https://personalization-edge.contentstack.com"
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const log = require('logToConsole');
const callInWindow = require('callInWindow');
const injectScript = require('injectScript');
const copyFromDataLayer = require('copyFromDataLayer');

const actionType = data.actionType;

const INITIALIZE = 'initialize';
const TRIGGER_IMPRESSIONS = 'triggerImpressions';
const TRIGGER_EVENT = 'triggerEvent';
const SET_ATTRIBUTES = 'setAttributes';
const SET_USER_ID = 'setUserId';
const RESET = 'reset';

function main() {
  if (actionType != INITIALIZE && !initializationCalled()) {
    failGTM('Cannot perform actions before initialization');
    return;
  }
  performAction();
}

function initializationCalled() {
  const initStatus = callInWindow('personalization.getInitializationStatus');

  return initStatus === undefined ? false : true;
}

function performAction() {
  switch (actionType) {
    case INITIALIZE: {
      const projectUid = data.projectUid;
      const personalizeSdkUrl = data.personalizeSdkUrl;
      const edgeApiUrl = data.edgeApiUrl;

      injectScript(personalizeSdkUrl, onSdkLoad, onSdkFailure, personalizeSdkUrl);
      break;
    }
    case TRIGGER_IMPRESSIONS: {
      const experiences = data.experiences;
      if (!experiences) {
        failGTM('Experience ShortUIDs cannot be empty');
        break;
      }
      const experienceShortUIDs = experiences.map((experience) => experience.shortUID);

      performTriggerImpressions(experienceShortUIDs);
      break;
    }
    case TRIGGER_EVENT:
      const eventKey = data.eventKey;
      if(!eventKey) {
        failGTM('Event Key cannot be empty');
      }
      performTriggerEvent(eventKey);
      break;
    case SET_ATTRIBUTES:
      const userAttributes = data.userAttributes;
      if(!userAttributes) {
        failGTM('User attributes cannot be empty');
        break;
      }
      const userAttributesObject = {};
      userAttributes.forEach(item => {
          if(item.attributeValue == "true") {
            item.attributeValue = true;
          }
          if(item.attributeValue == "false") {
            item.attributeValue = false;
          }
          userAttributesObject[item.attributeKey] = item.attributeValue;
      });
      performSetAttributes(userAttributesObject);
      break;
    case SET_USER_ID:
      const userId = copyFromDataLayer('data.email',2);
      const preserveUserAttributes = data.preserveUserAttributes;
      performSetUserId(userId, preserveUserAttributes);
      break;
    case RESET:
      performReset();
      break;
    default:
      failGTM('Please select a valid actionType');
      break;
  }
}

function onSdkLoad() {
  callInWindow('personalization.setEdgeApiUrl', data.edgeApiUrl);
  callInWindow('personalization.init', data.projectUid, { edgeMode: true });
  successGTM();
}

function onSdkFailure() {
  failGTM('Failed to load sdk');
}

function performTriggerImpressions(experienceShortUIDs) {
  experienceShortUIDs.forEach((experienceShortUID) => {
    callInWindow('personalization.triggerImpression', experienceShortUID);
  });
  successGTM();
}

function performTriggerEvent(eventKey) {
  callInWindow('personalization.triggerEvent', eventKey);
  successGTM();
}

function performSetAttributes(userAttributes) {
  callInWindow('personalization.set', userAttributes);
  successGTM();
}

function performSetUserId(userId, preserveUserAttributes) {
  if(preserveUserAttributes) {
    callInWindow('personalization.setUserId', userId, {preserveUserAttributes: true});
  } else {
    callInWindow('personalization.setUserId', userId);
  }
  
  successGTM();
}

function performReset() {
  callInWindow('personalization.reset');
  successGTM();
}

function failGTM(message) {
  if (message) {
    log(message);
  }
  data.gtmOnFailure();
}

function successGTM() {
  data.gtmOnSuccess();
}

main();


___WEB_PERMISSIONS___

[
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
                    "string": "personalization.getInitializationStatus"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
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
                    "string": "personalization.triggerImpression"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
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
                    "string": "personalization.init"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
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
                    "string": "personalization.triggerEvent"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
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
                    "string": "personalization.set"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
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
                    "string": "personalization.setUserId"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
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
                    "string": "personalization.reset"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
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
                    "string": "personalization.setEdgeApiUrl"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
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
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedKeys",
          "value": {
            "type": 1,
            "string": "any"
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
- name: injects sdk when initialize is selected
  code: |
    let success, failure;

    mock('injectScript', function (url, onSuccess, onFailure){
      success = onSuccess;
      failure = onFailure;
      onSuccess();
    });

    mockData.actionType = "initialize";

    runCode(mockData);

    const personalizeSdkUrl = mockData.personalizeSdkUrl;

    assertApi('injectScript').wasCalledWith(personalizeSdkUrl, success, failure, personalizeSdkUrl);

    assertApi('gtmOnSuccess').wasCalled();
    assertApi('gtmOnFailure').wasNotCalled();
- name: calls init when sdk is loaded and initialize is selected
  code: |
    let success, failure;

    mock('injectScript', function (url, onSuccess, onFailure){
      success = onSuccess;
      failure = onFailure;
      onSuccess();
    });

    mockData.actionType = "initialize";

    runCode(mockData);

    assertApi('callInWindow').wasCalledWith('personalization.setEdgeApiUrl', mockData.edgeApiUrl);
    assertApi('callInWindow').wasCalledWith('personalization.init', mockData.projectUid, {edgeMode:true});
- name: logs error and exits when sdk fails to load when initialize is selected
  code: |-
    let success, failure;

    mock('injectScript', function (url, onSuccess, onFailure){
      success = onSuccess;
      failure = onFailure;
      onFailure();
    });

    mockData.actionType = "initialize";

    runCode(mockData);

    const personalizeSdkUrl = mockData.personalizeSdkUrl;

    assertApi('injectScript').wasCalledWith(personalizeSdkUrl, success, failure, personalizeSdkUrl);

    assertApi('gtmOnFailure').wasCalled();
    assertApi('logToConsole').wasCalledWith('Failed to load sdk');
    assertApi('gtmOnSuccess').wasNotCalled();
- name: checks if init was called before performing actions
  code: |-
    mock('callInWindow', function(method){
      if(method === "personalization.getInitializationStatus"){
        return "initializing";
      }
    });

    const testExperiences = [{ shortUID: 'mockShortUID_one' }, { shortUID: 'mockShortUID_two' }];
    mockData.experiences = testExperiences;

    runCode(mockData);

    assertApi('callInWindow').wasCalledWith('personalization.getInitializationStatus');
- name: fails if initialize is not called before performing actions
  code: |-
    mock('callInWindow', function(method){
      if(method === "personalization.getInitializationStatus"){
        return undefined;
      }
    });

    runCode(mockData);

    assertApi('callInWindow').wasCalledWith('personalization.getInitializationStatus');
    assertApi('logToConsole').wasCalledWith('Cannot perform actions before initialization');
    assertApi('gtmOnFailure').wasCalled();
- name: triggers impressions for a list of experiences when triggerImpressions is
    selected
  code: |
    mockData.actionType = 'triggerImpressions';
    const testExperiences = [{ shortUID: 'mockShortUID_one' }, { shortUID: 'mockShortUID_two' }];
    mockData.experiences = testExperiences;

    mock('callInWindow', function (method) {
      if (method === 'personalization.getInitializationStatus') {
        return 'initializing';
      }
    });

    runCode(mockData);

    assertApi('callInWindow').wasCalledWith('personalization.triggerImpression', testExperiences[0].shortUID);
    assertApi('callInWindow').wasCalledWith('personalization.triggerImpression', testExperiences[1].shortUID);
    assertApi('gtmOnSuccess').wasCalled();
- name: fails if triggerImpressions is selected and did not input experienceShortUIDs
  code: |
    mockData.actionType = 'triggerImpressions';
    mock('callInWindow', function (method) {
      if (method === 'personalization.getInitializationStatus') {
        return 'initialzing';
      }
    });

    runCode(mockData);

    assertApi('logToConsole').wasCalledWith('Experience ShortUIDs cannot be empty');
    assertApi('gtmOnFailure').wasCalled();
- name: triggers event with eventkey when triggerEvent is selected
  code: |-
    mockData.actionType = "triggerEvent";
    mockData.eventKey = "mock-event";

    mock('callInWindow', function (method) {
      if(method === 'personalization.getInitializationStatus') {
        return 'initializing';
      }
    });

    runCode(mockData);

    assertApi('callInWindow').wasCalledWith('personalization.triggerEvent', 'mock-event');
    assertApi('gtmOnSuccess').wasCalled();
- name: fails if triggerEvent is selected and did not input eventKey
  code: |-
    mockData.actionType = "triggerEvent";

    mock('callInWindow', function (method) {
      if(method === 'personalization.getInitializationStatus') {
        return 'initializing';
      }
    });

    runCode(mockData);

    assertApi('logToConsole').wasCalledWith('Event Key cannot be empty');
    assertApi('gtmOnFailure').wasCalled();
- name: fails if the actionType is invalid
  code: |-
    mockData.actionType = undefined;

    mock('callInWindow', function (method) {
      if (method === 'personalization.getInitializationStatus') {
        return 'initializing';
      }
    });

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();
    assertApi('logToConsole').wasCalledWith('Please select a valid actionType');
- name: sets user attributes when action is selected as set attributes
  code: |-
    mockData.actionType = "setAttributes";
    mockData.userAttributes = [{"attributeKey":"mock-attribute","attributeValue":"true"}];

    mock('callInWindow', function (method) {
      if(method === 'personalization.getInitializationStatus') {
        return 'initializing';
      }
    });

    runCode(mockData);

    assertApi('callInWindow').wasCalledWith('personalization.set', {"mock-attribute":true});
    assertApi('gtmOnSuccess').wasCalled();
- name: fails to set user attributes if undefined
  code: |-
    mockData.actionType = "setAttributes";

    mock('callInWindow', function (method) {
      if(method === 'personalization.getInitializationStatus') {
        return 'initializing';
      }
    });

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();
- name: sets the user id when setUserId is selected and preserveUserAttributes is
    true
  code: |-
    mockData.actionType = "setUserId";
    mockData.preserveUserAttributes = true;

    mock('callInWindow', function (method) {
      if(method === 'personalization.getInitializationStatus') {
        return 'initializing';
      }
    });

    mock('copyFromDataLayer', function (object) {
      return 'mock-email@gmail.com';
    });
    runCode(mockData);

    const userId = 'mock-email@gmail.com';

    assertApi('callInWindow').wasCalledWith('personalization.setUserId', userId, {preserveUserAttributes: true});
    assertApi('gtmOnSuccess').wasCalled();
- name: sets the user id when setUserId is selected and preserveUserAttributes is
    false
  code: |-
    mockData.actionType = "setUserId";
    mockData.preserveUserAttributes = false;

    mock('callInWindow', function (method) {
      if(method === 'personalization.getInitializationStatus') {
        return 'initializing';
      }
    });

    mock('copyFromDataLayer', function (object) {
      return 'mock-email@gmail.com';
    });

    runCode(mockData);

    const userId = 'mock-email@gmail.com';

    assertApi('callInWindow').wasCalledWith('personalization.setUserId', userId);
    assertApi('gtmOnSuccess').wasCalled();
- name: resets the sdk when reset action is selected
  code: |-
    mockData.actionType = 'reset';

    mock('callInWindow', function (method) {
      if(method === 'personalization.getInitializationStatus') {
        return 'initializing';
      }
    });

    runCode(mockData);

    assertApi('callInWindow').wasCalledWith('personalization.reset');
    assertApi('gtmOnSuccess').wasCalled();
setup: |-
  const log = require('logToConsole');

  const mockData = {
    personalizeSdkUrl: 'mockURL',
    projectUid: 'mockProjectUID',
    edgeApiUrl: 'mockEdgeApiUrl',
  };


___NOTES___

Created on 16/02/2024, 11:10:48


