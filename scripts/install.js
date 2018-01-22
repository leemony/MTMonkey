'use strict';

const fs = require('fs');
const path = require('path');
const xcode = require('xcode');
const shelljs = require('shelljs');
const hostname = require('os').hostname();
const doctorIOS = require('macaca-doctor/lib/ios');

const DEVELOPMENT_TEAM = process.env.DEVELOPMENT_TEAM_ID || '';
const xctestwdFrameworksPrefix = 'xctestwd-frameworks-';

const update = function(project, schemeName, callback) {
  const myConfigKey = project.pbxTargetByName(schemeName).buildConfigurationList;
  const buildConfig = project.pbxXCConfigurationList()[myConfigKey];
  const configArray = buildConfig.buildConfigurations;
  const keys = configArray.map(item => item.value);
  const pbxXCBuildConfigurationSection = project.pbxXCBuildConfigurationSection();
  keys.forEach(key => {
    callback(pbxXCBuildConfigurationSection[key].buildSettings);
  });
};

const updateInformation = function() {
  try {
    const schemeName = 'XCTestWDUITests';
    const projectPath = path.join(__dirname, '..', 'XCTestWD', 'XCTestWD.xcodeproj', 'project.pbxproj');
    const myProj = xcode.project(projectPath);
    myProj.parseSync();

    update(myProj, schemeName, function(buildSettings) {
      const newBundleId = process.env.BUNDLE_ID || `XCTestWDRunner.XCTestWDRunner.${hostname}`;
      buildSettings.PRODUCT_BUNDLE_IDENTIFIER = newBundleId;
      if (DEVELOPMENT_TEAM) {
        buildSettings.DEVELOPMENT_TEAM = DEVELOPMENT_TEAM;
      }
    });

    const projSect = myProj.getFirstProject();
    const myRunnerTargetKey = myProj.findTargetKey(schemeName);
    const targetAttributes = projSect.firstProject.attributes.TargetAttributes;
    const runnerObj = targetAttributes[myRunnerTargetKey];
    if (DEVELOPMENT_TEAM) {
      runnerObj.DevelopmentTeam = DEVELOPMENT_TEAM;
    }

    fs.writeFileSync(projectPath, myProj.writeSync());

    if (DEVELOPMENT_TEAM) {
      console.log('Successfully updated Bundle Id and Team Id.');
    } else {
      console.log(`Successfully updated Bundle Id, but no Team Id was provided. Please update your team id manually in ${projectPath}, or reinstall the module with DEVELOPMENT_TEAM_ID in environment variable.`);
    }
    process.exit(0);
  } catch (e) {
    console.log('Failed to update Bundle Id and Team Id: ', e);
  }
};

doctorIOS.getXcodeVersion()
  .then(version => {
    const pkgName = `${xctestwdFrameworksPrefix}${version}`;
    const dir = require.resolve(pkgName);
    const originDir = path.join(dir, '..', 'Carthage');
    const distDir = path.join(__dirname, '..');
    shelljs.mv('-n', originDir, distDir);
    updateInformation();
  });
