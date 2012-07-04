## Tepacap

Tepacap is an overload of the capistrano's _run_ parallel command.

Add following features :

* Continue if one of the server is not reachable.
* Sort the output by server at the end of execution.

## Usage

Add this into your Capfile :

    require "tepacap"

You can have a different user for gateway and servers :

    set :user, "user_for_servers" # default user for servers and gateway

    set :gateway, "your_gateway_server"
    set :gateway_user, "user_for_gateway"

## Result

Here the server _parapluie-27.rennes.grid5000.fr_ is not reachable.

    grid5000-igrida :: (master) » cap provision:nodes
    * executing `provision:nodes'
    * executing "http_proxy=http://proxy:3128 puppet apply --modulepath /home/pmorillo/xps/grid5000-igrida/modules/ /home/pmorillo/xps/grid5000-igrida/puppet/manifests/node.pp"
    * Connected to parapluie-25.rennes.grid5000.fr...
    * Removing parapluie-27.rennes.grid5000.fr (root)...
    * Connected to parapluie-25.rennes.grid5000.fr...
    * Connected to parapluie-28.rennes.grid5000.fr...
    [stdout][parapluie-25.rennes.grid5000.fr] notice: Finished catalog run in 0.44 seconds
    [stdout][parapluie-28.rennes.grid5000.fr] notice: Finished catalog run in 0.24 seconds
    ---- parapluie-25.rennes.grid5000.fr -------------------------------------------------
    notice: Finished catalog run in 0.44 seconds
    ---- parapluie-28.rennes.grid5000.fr -------------------------------------------------
    notice: Finished catalog run in 0.24 seconds
    *** Servers unreachable : ["parapluie-27.rennes.grid5000.fr"]

## LICENSE:

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
