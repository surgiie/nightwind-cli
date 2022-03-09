<?php

namespace Nightwind;

use Nightwind\View;
use Illuminate\View\Factory;

class ViewFactory extends Factory
{

    /**
     * Disable dota notation normalization.
     *
     * @param string $name
     * @return void
     */
    protected function normalizeName($name)
    {
        return $name;
    }

    /**
     * Create a new view instance from the given arguments.
     *
     * @param  string  $view
     * @param  string  $path
     * @param  \Illuminate\Contracts\Support\Arrayable|array  $data
     * @return \Illuminate\Contracts\View\View
     */
    protected function viewInstance($view, $path, $data)
    {
        return new View($this, $this->getEngineFromPath($path), $view, $path, $data);
    }
    
}
