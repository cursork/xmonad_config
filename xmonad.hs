import XMonad
import XMonad.Config.Desktop (desktopLayoutModifiers)
import XMonad.Config.Gnome
import XMonad.Util.EZConfig
import XMonad.Actions.GridSelect
import XMonad.Actions.UpdatePointer
import XMonad.Actions.Volume
import XMonad.Layout.Magnifier
import XMonad.Layout.Tabbed
import qualified XMonad.StackSet as W

-- These applications always go to the same workspaces
-- N.B. float can be done like so:
	--[ className =? "title thing" --> doFloat ]
assignWorkspaceHook = composeAll
	[ className =? "Firefox"        --> doShift "2"
	, className =? "Update Manager" --> doShift "5"
	, className =? "Spotify"        --> doShift "7"
	, className =? "Buddy List"     --> doShift "8"
	, className =? "Thunderbird"    --> doShift "9" ]

-- Default layout with full replaced by tabbed and some slight magnification to
-- make tiled layouts 'pop' a bit more noticeably when moving windows
layout = desktopLayoutModifiers $ simpleTabbedBottom ||| (magnifiercz 1.0075 tiled) ||| (magnifiercz 1.0075 $ Mirror tiled)
	where
		tiled   = XMonad.Tall nmaster delta ratio
		nmaster = 1
		ratio   = 1/2
		delta   = 3/100

main = xmonad $ gnomeConfig
	{ borderWidth = 3
	, focusedBorderColor = "#009900"
	, modMask     = mod4Mask
	, manageHook  = assignWorkspaceHook <+> manageHook gnomeConfig
	, layoutHook  = layout
	, logHook     = updatePointer (Relative 0.5 0.5) }
	`additionalKeys`
	-- Launching things
	[ ((mod4Mask, xK_p),                 spawn "dmenu_run | dmenu -b")
	, ((mod4Mask, xK_f),                 spawn "firefox")
	, ((mod4Mask .|. shiftMask, xK_l),   spawn "gnome-screensaver-command -l")
	, ((mod4Mask, xK_g),                 spawn "gvim")
	, ((mod4Mask, xK_m),                 spawn "emacs")
	-- GridSelect on super-shift-tab
	, ((mod4Mask .|. shiftMask, xK_Tab), goToSelected defaultGSConfig)
	-- Volume
	, ((mod4Mask, xK_Page_Up),           raiseVolume 3 >> return ())
	, ((mod4Mask, xK_Page_Down),         lowerVolume 3 >> return ())
	, ((mod4Mask, xK_End),               toggleMute    >> return ()) ]

