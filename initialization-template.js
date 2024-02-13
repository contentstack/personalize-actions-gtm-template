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
  const options = { edgeMode: true };

  callInWindow('personalization.init', projectUid, options);

  gtmOnSuccess();
};

const checkFieldsAndInjectScript = () => {
  if (!personalizationURL) {
    log('personalizationSdkURL is missing');
    gtmOnFailure();
    return;
  }

  if (!projectUid) {
    log('projectUid is missing');
    gtmOnFailure();
    return;
  }

  injectScript(personalizationURL, initializePersonalization, gtmOnFailure, personalizationURL);
};

checkFieldsAndInjectScript();
