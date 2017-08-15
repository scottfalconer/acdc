<?php

namespace Acquia\Blt\Custom\Commands;

use Acquia\Blt\Robo\BltTasks;
use Acquia\Blt\Robo\Exceptions\BltException;
use Robo\Contract\VerbosityThresholdInterface;

/**
 * Defines commands in the "custom" namespace.
 */
class SetupC9Command extends BltTasks {

  protected $defaultLocalSettingsFile;
  protected $projectLocalSettingsFile;

  /**
   * This hook will fire for all commands in this command file.
   *
   * @hook init
   */
  public function initialize() {
    $this->defaultLocalSettingsFile = $this->getConfigValue('docroot') . '/sites/default/settings/default.local.settings.php';
    $this->projectLocalSettingsFile = $this->getConfigValue('docroot') . '/sites/default/settings/settings.local.php';
  }

  /**
   * Configure a C9 development environment.
   *
   * @command c9:setup
   * @description Configures a C9 development environment,.
   */
  public function setupc9() {
    if (!file_exists($this->projectLocalSettingsFile)) {
      $this->say("Generating C9 settings file...");
      $result = $this->taskFilesystemStack()
        ->copy($this->defaultLocalSettingsFile, $this->projectLocalSettingsFile)
        ->stopOnFail()
        ->setVerbosityThreshold(VerbosityThresholdInterface::VERBOSITY_VERBOSE)
        ->run();

      if (!$result->wasSuccessful()) {
        $filepath = $this->getInspector()->getFs()->makePathRelative($this->defaultLocalSettingsFile, $this->getConfigValue('docroot'));
        throw new BltException("Unable to copy $filepath into your repository.");
      }

      //  Replace the settings with C9 specific settings.
      $c9_db_user_string = "'username' => '". getenv('C9_USER') ."'";


      $result = $this->taskReplaceInFile($this->projectLocalSettingsFile)
        ->from("'database' => 'drupal'")
        ->to("'database' => 'c9'")
        ->run();

      $c9_db_user_string = "'username' => '". getenv('C9_USER') ."'";
      $result = $this->taskReplaceInFile($this->projectLocalSettingsFile)
        ->from("'username' => 'drupal'")
        ->to($c9_db_user_string)
        ->run();

      $result = $this->taskReplaceInFile($this->projectLocalSettingsFile)
        ->from("'password' => 'drupal',")
        ->to("'password' => '',")
        ->run();

    }
  }
}
