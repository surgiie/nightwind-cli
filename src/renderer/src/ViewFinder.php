<?php

namespace Nightwind;

use Illuminate\View\FileViewFinder;

class ViewFinder extends FileViewFinder
{
    /**
     * Overwritten to disable dot notation.
     *
     * @param  string  $name
     * @return array
     */
    protected function getPossibleViewFiles($name)
    {
        return array_map(function ($extension) use ($name) {
            return $name.'.'.$extension;
        }, $this->extensions);
    }

}
