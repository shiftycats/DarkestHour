//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHViewpointMessage extends LocalMessage
    abstract;

var localized string ViewpointCreatedText;
var localized string ViewpointDestroyedText;
var localized string ViewpointExpiredText;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.ViewpointDestroyedText;
        case 1:
            return default.ViewpointCreatedText;
        case 2:
            return default.ViewpointExpiredText;
    }
}

defaultproperties
{
    ViewpointCreatedText="A new viewpoint has been created by {observer}."
    ViewpointDestroyedText="This viewpoint has been destroyed."
}
