##Handling Animations In CoronaSDK   
   
      
        
If the animation on the object has the "Play On Load" checked, the animation will start once the level is loaded.

At some point you may need to stop it and change it to another animation.
  
Let consider the following scenario where the object we want to control has the unique name "player" and it has a couple of animations on it.  
The "idle" animation is automatically played on load.

<img src="./images/chapter2_playerAnims.png" style="height:350px">

At the top of your code file forward declare your player variable in order to be able to access the player anywhere in the lua file.

<pre class="prettyprint linenums lang-lua">
	local playerObject = nil; --forward declaration of player object
</pre>

After the level is loaded - search for the player and save it in the player variable.

<pre class="prettyprint linenums lang-lua">
		
--1 -> load your level file from the published subfolder
lhScene = LHScene:initWithContentOfFile("LH2-Published/example.json");		
--2 - > add your new loaded level to the scene group
sceneGroup:insert(lhScene);
	
playerObject = lhScene:getChildNodeWithUniqueName("player");				
</pre>

At this point you have access to the player object (the sprite object selected in the screenshot with unique name "player" that has multiple animations like "walk", "idle" "shoot", ...)


###Changing to another animation

First retrieve the animation you want and then activate the animation on the player object.   
<pre class="prettyprint linenums lang-lua">
local walkAnim = playerObject:getAnimationWithName("walk");
--this returns a LHAnimation object

playerObject:setActiveAnimation(walkAnim);
</pre>
Look inside LHAnimationsProtocol API doc for all available methods.  
The getAnimationWithName method returns a LHAnimation object.  
Look inside LHAnimation API doc for all available methods.   
 
The LHAnimation has a state of its own so if it was previously played, when you activate it again, it will continue from where it was previously left.  
If it was previously paused it will stay paused when activated also.  
<pre class="prettyprint linenums lang-lua">

walkAnim:restart()--set the animation at the beginning
walkAnim:setAnimating(true)--unpause animation if needed

</pre>

###Play animation frame by frame
In the scenario where you have an animation containig multiple frames that you want to manually change, like in the case of the pigs from Angry Birds where their faces represents the damage taken (healty, partially damaged, fully damaged, dead) you can do as follows:  

<pre class="prettyprint linenums lang-lua">

local stateAnimObj = playerObject:getAnimationWithName("stateAnimation");
	
stateAnimObj:setAnimating(false);
pigObj:setActiveAnimation(stateAnimObj);
		
--stateAnimObj:setCurrentFrame(1);--healty
stateAnimObj:setCurrentFrame(2);--partially damaged
--stateAnimObj:setCurrentFrame(3);--fully damaged
--stateAnimObj:setCurrentFrame(4);--dead

</pre>

To retrieve the total frames in the animation you will do
<pre class="prettyprint linenums lang-lua">

local numberOfFrames = stateAnimObj:totalFrames();

</pre>
  

  