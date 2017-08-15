<?php

namespace Acquia\Blt\Custom\Commands;

use Acquia\Blt\Robo\BltTasks;

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
    $this->projectLocalSettingsFile = $this->getConfigValue('docroot') . '/sites/default/settings/settings.local.php';
  }

  /**
   * Configure a C9 development environment.
   *
   * @command c9:setup
   * @description Configures a C9 development environment,.
   */
  public function setupc9() {

    $this->say("Adding C9 settings to settings.local.php...");

    //  Replace the settings with C9 specific settings.
    $c9_db_user_string = "'username' => '". getenv('C9_USER') ."'";

    $result = $this->taskReplaceInFile($this->projectLocalSettingsFile)
      ->from("'database' => 'drupal'")
      ->to("'database' => 'c9'")
      ->run();

    $c9_db_user_string = "'username' => '". getenv('C9_USER') ."'";
    $this->say('Configuring local.settings.php for user: ' . getenv('C9_USER'));
    $result = $this->taskReplaceInFile($this->projectLocalSettingsFile)
      ->from("'username' => 'drupal'")
      ->to($c9_db_user_string)
      ->run();

    $result = $this->taskReplaceInFile($this->projectLocalSettingsFile)
      ->from("'password' => 'dupal',")
      ->to("'password' => '',")
      ->run();
  }
}
