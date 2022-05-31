<?php

namespace Nightwind;

use SplFileInfo;
use Dotenv\Dotenv;
use BladeCLI\Blade;
use Illuminate\Support\Str;
use Nightwind\Support\JsonFileLoader;
use BladeCLI\Support\OptionsParser;
use Illuminate\Container\Container;
use Illuminate\Filesystem\Filesystem;

final class Renderer
{

    /**
     * Construct new Renderer instance.
     *
     * @param array $args
     * @param string $workingDirectory
     */
    public function __construct(array $args, string $workingDirectory)
    {
        $this->workingDirectory = $workingDirectory;
        $this->setArgs($args);
    }

    /**
     * Set args for rendering.
     *
     * @param array $argv
     * @return static
     */
    public function setArgs(array $argv = [])
    {
        $this->args = $argv;
      
        return $this;
    }

    /**
     * Get env file path for project..
     *
     * @return array
     */
    protected function gatherEnvData()
    {
        $file = $this->workingDirectory.'/.env';

        return file_exists($file) ? Dotenv::parse(file_get_contents($file)) : [];
    }

    /**
     * Gather json variables file data.
     *
     * @return array
     */
    protected function gatherJsonData()
    {
        $file = $this->workingDirectory.'/variables.json';

        return file_exists($file) ? (new JsonFileLoader)->loadJsonFile($file) : [];
    }

    /**
     * Get data from command line options/argv.
     *
     * @return array
     */
    protected function gatherCommandLineData()
    {
        $parser = new OptionsParser(array_filter($this->args));
        return $parser->parse(mode: OptionsParser::VALUE_MODE);
    }
    
    /**
     * Create the save directory for the file being rendered.
     *
     * @param SplFileInfo $file
     * @return string
     */
    protected function handleFileSaveDirectory(SplFileInfo $file)
    {
        $dir = Str::after($file->getPath(), basename($this->workingDirectory). "/");

        $saveDir = $this->workingDirectory . "/rendered";

        $saveDir = $saveDir. '/' . ltrim(str_replace("templates", "", $dir), '/');

        @mkdir($saveDir, recursive:true);

        return realpath($saveDir);
    }

    /**
     * Render the file path.
     *
     * @param \SplFileInfo $path
     * @return \BladeCLI\Blade
     */
    public function render(SplFileInfo $file)
    {
        $blade = new Blade(
            container: new Container,
            filesystem: new Filesystem,
            filePath: $file->getPathName(),
            options: [
                'force' => true,
                'save-directory' =>$this->handleFileSaveDirectory($file), 
            ]
        );

        $blade->render($this->gatherData());

        return $blade;
    }

    /**
     * Gather all data to be used for rendering.
     *
     * @return array
     */
    protected function gatherData()
    {
        $data = [];

        $variables = array_merge(
            $this->gatherJsonData(),
            $this->gatherEnvData(),
            $this->gatherCommandLineData()
        );
        foreach ($variables as $k => $v) {
            // normalize variable keys to camel case.
            $k = Str::camel(Str::snake(strtolower($k)));
            $data[$k] = $v;
        }
        
        return $data;
    }
}
