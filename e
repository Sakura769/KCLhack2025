GIT-PUSH(1)                                         Git Manual                                         GIT-PUSH(1)

NNAAMMEE
       git-push - Update remote refs along with associated objects

SSYYNNOOPPSSIISS
       _g_i_t _p_u_s_h [--all | --mirror | --tags] [--follow-tags] [--atomic] [-n | --dry-run] [--receive-pack=<git-receive-pack>]
                  [--repo=<repository>] [-f | --force] [-d | --delete] [--prune] [-v | --verbose]
                  [-u | --set-upstream] [-o <string> | --push-option=<string>]
                  [--[no-]signed|--signed=(true|false|if-asked)]
                  [--force-with-lease[=<refname>[:<expect>]] [--force-if-includes]]
                  [--no-verify] [<repository> [<refspec>...]]

DDEESSCCRRIIPPTTIIOONN
       Updates remote refs using local refs, while sending objects necessary to complete the given refs.

       You can make interesting things happen to a repository every time you push into it, by setting up _h_o_o_k_s
       there. See documentation for ggiitt--rreecceeiivvee--ppaacckk(1).

       When the command line does not specify where to push with the <<rreeppoossiittoorryy>> argument, bbrraanncchh..**..rreemmoottee
       configuration for the current branch is consulted to determine where to push. If the configuration is
       missing, it defaults to _o_r_i_g_i_n.

       When the command line does not specify what to push with <<rreeffssppeecc>>...... arguments or ----aallll, ----mmiirrrroorr, ----ttaaggss
       options, the command finds the default <<rreeffssppeecc>> by consulting rreemmoottee..**..ppuusshh configuration, and if it is
       not found, honors ppuusshh..ddeeffaauulltt configuration to decide what to push (See ggiitt--ccoonnffiigg(1) for the meaning of
       ppuusshh..ddeeffaauulltt).

       When neither the command-line nor the configuration specify what to push, the default behavior is used,
       which corresponds to the ssiimmppllee value for ppuusshh..ddeeffaauulltt: the current branch is pushed to the corresponding
       upstream branch, but as a safety measure, the push is aborted if the upstream branch does not have the same
       name as the local one.

OOPPTTIIOONNSS
       <repository>
           The "remote" repository that is destination of a push operation. This parameter can be either a URL
           (see the section GIT URLS below) or the name of a remote (see the section REMOTES below).

       <refspec>...
           Specify what destination ref to update with what source object. The format of a <refspec> parameter is
           an optional plus ++, followed by the source object <src>, followed by a colon ::, followed by the
           destination ref <dst>.

           The <src> is often the name of the branch you would want to push, but it can be any arbitrary "SHA-1
           expression", such as mmaasstteerr~~44 or HHEEAADD (see ggiittrreevviissiioonnss(7)).

           The <dst> tells which ref on the remote side is updated with this push. Arbitrary expressions cannot be
           used here, an actual ref must be named. If ggiitt ppuusshh [[<<rreeppoossiittoorryy>>]] without any <<rreeffssppeecc>> argument is
           set to update some ref at the destination with <<ssrrcc>> with rreemmoottee..<<rreeppoossiittoorryy>>..ppuusshh configuration
           variable, ::<<ddsstt>> part can be omitted—such a push will update a ref that <<ssrrcc>> normally updates without
           any <<rreeffssppeecc>> on the command line. Otherwise, missing ::<<ddsstt>> means to update the same ref as the <<ssrrcc>>.

           If <dst> doesn’t start with rreeffss// (e.g.  rreeffss//hheeaaddss//mmaasstteerr) we will try to infer where in rreeffss//** on the
           destination <repository> it belongs based on the type of <src> being pushed and whether <dst> is
           ambiguous.

           •   If <dst> unambiguously refers to a ref on the <repository> remote, then push to that ref.

           •   If <src> resolves to a ref starting with refs/heads/ or refs/tags/, then prepend that to <dst>.

           •   Other ambiguity resolutions might be added in the future, but for now any other cases will error
               out with an error indicating what we tried, and depending on the aaddvviiccee..ppuusshhUUnnqquuaalliiffiieeddRReeffnnaammee
               configuration (see ggiitt--ccoonnffiigg(1)) suggest what refs/ namespace you may have wanted to push to.

           The object referenced by <src> is used to update the <dst> reference on the remote side. Whether this
           is allowed depends on where in rreeffss//** the <dst> reference lives as described in detail below, in those
           sections "update" means any modifications except deletes, which as noted after the next few sections
           are treated differently.

           The rreeffss//hheeaaddss//** namespace will only accept commit objects, and updates only if they can be
           fast-forwarded.

           The rreeffss//ttaaggss//** namespace will accept any kind of object (as commits, trees and blobs can be tagged),
           and any updates to them will be rejected.

           It’s possible to push any type of object to any namespace outside of rreeffss//{{ttaaggss,,hheeaaddss}}//**. In the case
           of tags and commits, these will be treated as if they were the commits inside rreeffss//hheeaaddss//** for the
           purposes of whether the update is allowed.

           I.e. a fast-forward of commits and tags outside rreeffss//{{ttaaggss,,hheeaaddss}}//** is allowed, even in cases where
           what’s being fast-forwarded is not a commit, but a tag object which happens to point to a new commit
           which is a fast-forward of the commit the last tag (or commit) it’s replacing. Replacing a tag with an
           entirely different tag is also allowed, if it points to the same commit, as well as pushing a peeled
           tag, i.e. pushing the commit that existing tag object points to, or a new tag object which an existing
           commit points to.

           Tree and blob objects outside of rreeffss//{{ttaaggss,,hheeaaddss}}//** will be treated the same way as if they were
           inside rreeffss//ttaaggss//**, any update of them will be rejected.

           All of the rules described above about what’s not allowed as an update can be overridden by adding an
           the optional leading ++ to a refspec (or using ----ffoorrccee command line option). The only exception to this
           is that no amount of forcing will make the rreeffss//hheeaaddss//** namespace accept a non-commit object. Hooks and
           configuration can also override or amend these rules, see e.g.  rreecceeiivvee..ddeennyyNNoonnFFaassttFFoorrwwaarrddss in ggiitt--
           ccoonnffiigg(1) and pprree--rreecceeiivvee and uuppddaattee in ggiitthhooookkss(5).

           Pushing an empty <src> allows you to delete the <dst> ref from the remote repository. Deletions are
           always accepted without a leading ++ in the refspec (or ----ffoorrccee), except when forbidden by configuration
           or hooks. See rreecceeiivvee..ddeennyyDDeelleetteess in ggiitt--ccoonnffiigg(1) and pprree--rreecceeiivvee and uuppddaattee in ggiitthhooookkss(5).

           The special refspec :: (or ++:: to allow non-fast-forward updates) directs Git to push "matching"
           branches: for every branch that exists on the local side, the remote side is updated if a branch of the
           same name already exists on the remote side.

           ttaagg <<ttaagg>> means the same as rreeffss//ttaaggss//<<ttaagg>>::rreeffss//ttaaggss//<<ttaagg>>.

       --all
           Push all branches (i.e. refs under rreeffss//hheeaaddss//); cannot be used with other <refspec>.

       --prune
           Remove remote branches that don’t have a local counterpart. For example a remote branch ttmmpp will be
           removed if a local branch with the same name doesn’t exist any more. This also respects refspecs, e.g.
           ggiitt ppuusshh ----pprruunnee rreemmoottee rreeffss//hheeaaddss//**::rreeffss//ttmmpp//** would make sure that remote rreeffss//ttmmpp//ffoooo will be
           removed if rreeffss//hheeaaddss//ffoooo doesn’t exist.

       --mirror
           Instead of naming each ref to push, specifies that all refs under rreeffss// (which includes but is not
           limited to rreeffss//hheeaaddss//, rreeffss//rreemmootteess//, and rreeffss//ttaaggss//) be mirrored to the remote repository. Newly
           created local refs will be pushed to the remote end, locally updated refs will be force updated on the
           remote end, and deleted refs will be removed from the remote end. This is the default if the
           configuration option rreemmoottee..<<rreemmoottee>>..mmiirrrroorr is set.

       -n, --dry-run
           Do everything except actually send the updates.

       --porcelain
           Produce machine-readable output. The output status line for each ref will be tab-separated and sent to
           stdout instead of stderr. The full symbolic names of the refs will be given.

       -d, --delete
           All listed refs are deleted from the remote repository. This is the same as prefixing all refs with a
           colon.

       --tags
           All refs under rreeffss//ttaaggss are pushed, in addition to refspecs explicitly listed on the command line.

       --follow-tags
           Push all the refs that would be pushed without this option, and also push annotated tags in rreeffss//ttaaggss
           that are missing from the remote but are pointing at commit-ish that are reachable from the refs being
           pushed. This can also be specified with configuration variable ppuusshh..ffoolllloowwTTaaggss. For more information,
           see ppuusshh..ffoolllloowwTTaaggss in ggiitt--ccoonnffiigg(1).

       --[no-]signed, --signed=(true|false|if-asked)
           GPG-sign the push request to update refs on the receiving side, to allow it to be checked by the hooks
           and/or be logged. If ffaallssee or ----nnoo--ssiiggnneedd, no signing will be attempted. If ttrruuee or ----ssiiggnneedd, the push
           will fail if the server does not support signed pushes. If set to iiff--aasskkeedd, sign if and only if the
           server supports signed pushes. The push will also fail if the actual call to ggppgg ----ssiiggnn fails. See ggiitt--
           rreecceeiivvee--ppaacckk(1) for the details on the receiving end.

       --[no-]atomic
           Use an atomic transaction on the remote side if available. Either all refs are updated, or on error, no
           refs are updated. If the server does not support atomic pushes the push will fail.

       -o <option>, --push-option=<option>
           Transmit the given string to the server, which passes them to the pre-receive as well as the
           post-receive hook. The given string must not contain a NUL or LF character. When multiple
           ----ppuusshh--ooppttiioonn==<<ooppttiioonn>> are given, they are all sent to the other side in the order listed on the
           command line. When no ----ppuusshh--ooppttiioonn==<<ooppttiioonn>> is given from the command line, the values of
           configuration variable ppuusshh..ppuusshhOOppttiioonn are used instead.

       --receive-pack=<git-receive-pack>, --exec=<git-receive-pack>
           Path to the _g_i_t_-_r_e_c_e_i_v_e_-_p_a_c_k program on the remote end. Sometimes useful when pushing to a remote
           repository over ssh, and you do not have the program in a directory on the default $PATH.

       --[no-]force-with-lease, --force-with-lease=<refname>, --force-with-lease=<refname>:<expect>
           Usually, "git push" refuses to update a remote ref that is not an ancestor of the local ref used to
           overwrite it.

           This option overrides this restriction if the current value of the remote ref is the expected value.
           "git push" fails otherwise.

           Imagine that you have to rebase what you have already published. You will have to bypass the "must
           fast-forward" rule in order to replace the history you originally published with the rebased history.
           If somebody else built on top of your original history while you are rebasing, the tip of the branch at
           the remote may advance with their commit, and blindly pushing with ----ffoorrccee will lose their work.

           This option allows you to say that you expect the history you are updating is what you rebased and want
           to replace. If the remote ref still points at the commit you specified, you can be sure that no other
           people did anything to the ref. It is like taking a "lease" on the ref without explicitly locking it,
           and the remote ref is updated only if the "lease" is still valid.

           ----ffoorrccee--wwiitthh--lleeaassee alone, without specifying the details, will protect all remote refs that are going
           to be updated by requiring their current value to be the same as the remote-tracking branch we have for
           them.

           ----ffoorrccee--wwiitthh--lleeaassee==<<rreeffnnaammee>>, without specifying the expected value, will protect the named ref
           (alone), if it is going to be updated, by requiring its current value to be the same as the
           remote-tracking branch we have for it.

           ----ffoorrccee--wwiitthh--lleeaassee==<<rreeffnnaammee>>::<<eexxppeecctt>> will protect the named ref (alone), if it is going to be updated,
           by requiring its current value to be the same as the specified value <<eexxppeecctt>> (which is allowed to be
           different from the remote-tracking branch we have for the refname, or we do not even have to have such
           a remote-tracking branch when this form is used). If <<eexxppeecctt>> is the empty string, then the named ref
           must not already exist.

           Note that all forms other than ----ffoorrccee--wwiitthh--lleeaassee==<<rreeffnnaammee>>::<<eexxppeecctt>> that specifies the expected
           current value of the ref explicitly are still experimental and their semantics may change as we gain
           experience with this feature.

           "--no-force-with-lease" will cancel all the previous --force-with-lease on the command line.

           A general note on safety: supplying this option without an expected value, i.e. as ----ffoorrccee--wwiitthh--lleeaassee
           or ----ffoorrccee--wwiitthh--lleeaassee==<<rreeffnnaammee>> interacts very badly with anything that implicitly runs ggiitt ffeettcchh on
           the remote to be pushed to in the background, e.g.  ggiitt ffeettcchh oorriiggiinn on your repository in a cronjob.

           The protection it offers over ----ffoorrccee is ensuring that subsequent changes your work wasn’t based on
           aren’t clobbered, but this is trivially defeated if some background process is updating refs in the
           background. We don’t have anything except the remote tracking info to go by as a heuristic for refs
           you’re expected to have seen & are willing to clobber.

           If your editor or some other system is running ggiitt ffeettcchh in the background for you a way to mitigate
           this is to simply set up another remote:

               git remote add origin-push $(git config remote.origin.url)
               git fetch origin-push

           Now when the background process runs ggiitt ffeettcchh oorriiggiinn the references on oorriiggiinn--ppuusshh won’t be updated,
           and thus commands like:

               git push --force-with-lease origin-push

           Will fail unless you manually run ggiitt ffeettcchh oorriiggiinn--ppuusshh. This method is of course entirely defeated by
           something that runs ggiitt ffeettcchh ----aallll, in that case you’d need to either disable it or do something more
           tedious like:

               git fetch              # update 'master' from remote
               git tag base master    # mark our base point
               git rebase -i master   # rewrite some commits
               git push --force-with-lease=master:base master:master

           I.e. create a bbaassee tag for versions of the upstream code that you’ve seen and are willing to overwrite,
           then rewrite history, and finally force push changes to mmaasstteerr if the remote version is still at bbaassee,
           regardless of what your local rreemmootteess//oorriiggiinn//mmaasstteerr has been updated to in the background.

           Alternatively, specifying ----ffoorrccee--iiff--iinncclluuddeess as an ancillary option along with
           ----ffoorrccee--wwiitthh--lleeaassee[[==<<rreeffnnaammee>>]] (i.e., without saying what exact commit the ref on the remote side must
           be pointing at, or which refs on the remote side are being protected) at the time of "push" will verify
           if updates from the remote-tracking refs that may have been implicitly updated in the background are
           integrated locally before allowing a forced update.

       -f, --force
           Usually, the command refuses to update a remote ref that is not an ancestor of the local ref used to
           overwrite it. Also, when ----ffoorrccee--wwiitthh--lleeaassee option is used, the command refuses to update a remote ref
           whose current value does not match what is expected.

           This flag disables these checks, and can cause the remote repository to lose commits; use it with care.

           Note that ----ffoorrccee applies to all the refs that are pushed, hence using it with ppuusshh..ddeeffaauulltt set to
           mmaattcchhiinngg or with multiple push destinations configured with rreemmoottee..**..ppuusshh may overwrite refs other than
           the current branch (including local refs that are strictly behind their remote counterpart). To force a
           push to only one branch, use a ++ in front of the refspec to push (e.g ggiitt ppuusshh oorriiggiinn ++mmaasstteerr to force
           a push to the mmaasstteerr branch). See the <<rreeffssppeecc>>......  section above for details.

       --[no-]force-if-includes
           Force an update only if the tip of the remote-tracking ref has been integrated locally.

           This option enables a check that verifies if the tip of the remote-tracking ref is reachable from one
           of the "reflog" entries of the local branch based in it for a rewrite. The check ensures that any
           updates from the remote have been incorporated locally by rejecting the forced update if that is not
           the case.

           If the option is passed without specifying ----ffoorrccee--wwiitthh--lleeaassee, or specified along with
           ----ffoorrccee--wwiitthh--lleeaassee==<<rreeffnnaammee>>::<<eexxppeecctt>>, it is a "no-op".

           Specifying ----nnoo--ffoorrccee--iiff--iinncclluuddeess disables this behavior.

       --repo=<repository>
           This option is equivalent to the <repository> argument. If both are specified, the command-line
           argument takes precedence.

       -u, --set-upstream
           For every branch that is up to date or successfully pushed, add upstream (tracking) reference, used by
           argument-less ggiitt--ppuullll(1) and other commands. For more information, see bbrraanncchh..<<nnaammee>>..mmeerrggee in ggiitt--
           ccoonnffiigg(1).

       --[no-]thin
           These options are passed to ggiitt--sseenndd--ppaacckk(1). A thin transfer significantly reduces the amount of sent
           data when the sender and receiver share many of the same objects in common. The default is ----tthhiinn.

       -q, --quiet
           Suppress all output, including the listing of updated refs, unless an error occurs. Progress is not
           reported to the standard error stream.

       -v, --verbose
           Run verbosely.

       --progress
           Progress status is reported on the standard error stream by default when it is attached to a terminal,
           unless -q is specified. This flag forces progress status even if the standard error stream is not
           directed to a terminal.

       --no-recurse-submodules, --recurse-submodules=check|on-demand|only|no
           May be used to make sure all submodule commits used by the revisions to be pushed are available on a
           remote-tracking branch. If _c_h_e_c_k is used Git will verify that all submodule commits that changed in the
           revisions to be pushed are available on at least one remote of the submodule. If any commits are
           missing the push will be aborted and exit with non-zero status. If _o_n_-_d_e_m_a_n_d is used all submodules
           that changed in the revisions to be pushed will be pushed. If on-demand was not able to push all
           necessary revisions it will also be aborted and exit with non-zero status. If _o_n_l_y is used all
           submodules will be recursively pushed while the superproject is left unpushed. A value of _n_o or using
           ----nnoo--rreeccuurrssee--ssuubbmmoodduulleess can be used to override the push.recurseSubmodules configuration variable when
           no submodule recursion is required.

       --[no-]verify
           Toggle the pre-push hook (see ggiitthhooookkss(5)). The default is --verify, giving the hook a chance to
           prevent the push. With --no-verify, the hook is bypassed completely.

       -4, --ipv4
           Use IPv4 addresses only, ignoring IPv6 addresses.

       -6, --ipv6
           Use IPv6 addresses only, ignoring IPv4 addresses.

GGIITT UURRLLSS
       In general, URLs contain information about the transport protocol, the address of the remote server, and
       the path to the repository. Depending on the transport protocol, some of this information may be absent.

       Git supports ssh, git, http, and https protocols (in addition, ftp, and ftps can be used for fetching, but
       this is inefficient and deprecated; do not use it).

       The native transport (i.e. git:// URL) does no authentication and should be used with caution on unsecured
       networks.

       The following syntaxes may be used with them:

       •   ssh://[user@]host.xz[:port]/path/to/repo.git/

       •   git://host.xz[:port]/path/to/repo.git/

       •   http[s]://host.xz[:port]/path/to/repo.git/

       •   ftp[s]://host.xz[:port]/path/to/repo.git/

       An alternative scp-like syntax may also be used with the ssh protocol:

       •   [user@]host.xz:path/to/repo.git/

       This syntax is only recognized if there are no slashes before the first colon. This helps differentiate a
       local path that contains a colon. For example the local path ffoooo::bbaarr could be specified as an absolute path
       or ..//ffoooo::bbaarr to avoid being misinterpreted as an ssh url.

       The ssh and git protocols additionally support ~username expansion:

       •   ssh://[user@]host.xz[:port]/~[user]/path/to/repo.git/

       •   git://host.xz[:port]/~[user]/path/to/repo.git/

       •   [user@]host.xz:/~[user]/path/to/repo.git/

       For local repositories, also supported by Git natively, the following syntaxes may be used:

       •   /path/to/repo.git/

       •   file:///path/to/repo.git/

       These two syntaxes are mostly equivalent, except when cloning, when the former implies --local option. See
       ggiitt--cclloonnee(1) for details.

       _g_i_t _c_l_o_n_e, _g_i_t _f_e_t_c_h and _g_i_t _p_u_l_l, but not _g_i_t _p_u_s_h, will also accept a suitable bundle file. See ggiitt--
       bbuunnddllee(1).

       When Git doesn’t know how to handle a certain transport protocol, it attempts to use the _r_e_m_o_t_e_-_<_t_r_a_n_s_p_o_r_t_>
       remote helper, if one exists. To explicitly request a remote helper, the following syntax may be used:

       •   <transport>::<address>

       where <address> may be a path, a server and path, or an arbitrary URL-like string recognized by the
       specific remote helper being invoked. See ggiittrreemmoottee--hheellppeerrss(7) for details.

       If there are a large number of similarly-named remote repositories and you want to use a different format
       for them (such that the URLs you use will be rewritten into URLs that work), you can create a configuration
       section of the form:

                   [url "<actual url base>"]
                           insteadOf = <other url base>

       For example, with this:

                   [url "git://git.host.xz/"]
                           insteadOf = host.xz:/path/to/
                           insteadOf = work:

       a URL like "work:repo.git" or like "host.xz:/path/to/repo.git" will be rewritten in any context that takes
       a URL to be "git://git.host.xz/repo.git".

       If you want to rewrite URLs for push only, you can create a configuration section of the form:

                   [url "<actual url base>"]
                           pushInsteadOf = <other url base>

       For example, with this:

                   [url "ssh://example.org/"]
                           pushInsteadOf = git://example.org/

       a URL like "git://example.org/path/to/repo.git" will be rewritten to "ssh://example.org/path/to/repo.git"
       for pushes, but pulls will still use the original URL.

RREEMMOOTTEESS
       The name of one of the following can be used instead of a URL as <<rreeppoossiittoorryy>> argument:

       •   a remote in the Git configuration file: $$GGIITT__DDIIRR//ccoonnffiigg,

       •   a file in the $$GGIITT__DDIIRR//rreemmootteess directory, or

       •   a file in the $$GGIITT__DDIIRR//bbrraanncchheess directory.

       All of these also allow you to omit the refspec from the command line because they each contain a refspec
       which git will use by default.

   NNaammeedd rreemmoottee iinn ccoonnffiigguurraattiioonn ffiillee
       You can choose to provide the name of a remote which you had previously configured using ggiitt--rreemmoottee(1),
       ggiitt--ccoonnffiigg(1) or even by a manual edit to the $$GGIITT__DDIIRR//ccoonnffiigg file. The URL of this remote will be used to
       access the repository. The refspec of this remote will be used by default when you do not provide a refspec
       on the command line. The entry in the config file would appear like this:

                   [remote "<name>"]
                           url = <url>
                           pushurl = <pushurl>
                           push = <refspec>
                           fetch = <refspec>

       The <<ppuusshhuurrll>> is used for pushes only. It is optional and defaults to <<uurrll>>.

   NNaammeedd ffiillee iinn $$GGIITT__DDIIRR//rreemmootteess
       You can choose to provide the name of a file in $$GGIITT__DDIIRR//rreemmootteess. The URL in this file will be used to
       access the repository. The refspec in this file will be used as default when you do not provide a refspec
       on the command line. This file should have the following format:

                   URL: one of the above URL format
                   Push: <refspec>
                   Pull: <refspec>

       PPuusshh:: lines are used by _g_i_t _p_u_s_h and PPuullll:: lines are used by _g_i_t _p_u_l_l and _g_i_t _f_e_t_c_h. Multiple PPuusshh:: and
       PPuullll:: lines may be specified for additional branch mappings.

   NNaammeedd ffiillee iinn $$GGIITT__DDIIRR//bbrraanncchheess
       You can choose to provide the name of a file in $$GGIITT__DDIIRR//bbrraanncchheess. The URL in this file will be used to
       access the repository. This file should have the following format:

                   <url>#<head>

       <<uurrll>> is required; ##<<hheeaadd>> is optional.

       Depending on the operation, git will use one of the following refspecs, if you don’t provide one on the
       command line. <<bbrraanncchh>> is the name of this file in $$GGIITT__DDIIRR//bbrraanncchheess and <<hheeaadd>> defaults to mmaasstteerr.

       git fetch uses:

                   refs/heads/<head>:refs/heads/<branch>

       git push uses:

                   HEAD:refs/heads/<head>

OOUUTTPPUUTT
       The output of "git push" depends on the transport method used; this section describes the output when
       pushing over the Git protocol (either locally or via ssh).

       The status of the push is output in tabular form, with each line representing the status of a single ref.
       Each line is of the form:

            <flag> <summary> <from> -> <to> (<reason>)

       If --porcelain is used, then each line of the output is of the form:

            <flag> \t <from>:<to> \t <summary> (<reason>)

       The status of up-to-date refs is shown only if --porcelain or --verbose option is used.

       flag
           A single character indicating the status of the ref:

           (space)
               for a successfully pushed fast-forward;

           ++
               for a successful forced update;

           --
               for a successfully deleted ref;

           **
               for a successfully pushed new ref;

           !!
               for a ref that was rejected or failed to push; and

           ==
               for a ref that was up to date and did not need pushing.

       summary
           For a successfully pushed ref, the summary shows the old and new values of the ref in a form suitable
           for using as an argument to ggiitt lloogg (this is <<oolldd>>....<<nneeww>> in most cases, and <<oolldd>>......<<nneeww>> for forced
           non-fast-forward updates).

           For a failed update, more details are given:

           rejected
               Git did not try to send the ref at all, typically because it is not a fast-forward and you did not
               force the update.

           remote rejected
               The remote end refused the update. Usually caused by a hook on the remote side, or because the
               remote repository has one of the following safety options in effect: rreecceeiivvee..ddeennyyCCuurrrreennttBBrraanncchh (for
               pushes to the checked out branch), rreecceeiivvee..ddeennyyNNoonnFFaassttFFoorrwwaarrddss (for forced non-fast-forward
               updates), rreecceeiivvee..ddeennyyDDeelleetteess or rreecceeiivvee..ddeennyyDDeelleetteeCCuurrrreenntt. See ggiitt--ccoonnffiigg(1).

           remote failure
               The remote end did not report the successful update of the ref, perhaps because of a temporary
               error on the remote side, a break in the network connection, or other transient error.

       from
           The name of the local ref being pushed, minus its rreeffss//<<ttyyppee>>// prefix. In the case of deletion, the
           name of the local ref is omitted.

       to
           The name of the remote ref being updated, minus its rreeffss//<<ttyyppee>>// prefix.

       reason
           A human-readable explanation. In the case of successfully pushed refs, no explanation is needed. For a
           failed ref, the reason for failure is described.

NNOOTTEE AABBOOUUTT FFAASSTT--FFOORRWWAARRDDSS
       When an update changes a branch (or more in general, a ref) that used to point at commit A to point at
       another commit B, it is called a fast-forward update if and only if B is a descendant of A.

       In a fast-forward update from A to B, the set of commits that the original commit A built on top of is a
       subset of the commits the new commit B builds on top of. Hence, it does not lose any history.

       In contrast, a non-fast-forward update will lose history. For example, suppose you and somebody else
       started at the same commit X, and you built a history leading to commit B while the other person built a
       history leading to commit A. The history looks like this:

                 B
                /
            ---X---A

       Further suppose that the other person already pushed changes leading to A back to the original repository
       from which you two obtained the original commit X.

       The push done by the other person updated the branch that used to point at commit X to point at commit A.
       It is a fast-forward.

       But if you try to push, you will attempt to update the branch (that now points at A) with commit B. This
       does _n_o_t fast-forward. If you did so, the changes introduced by commit A will be lost, because everybody
       will now start building on top of B.

       The command by default does not allow an update that is not a fast-forward to prevent such loss of history.

       If you do not want to lose your work (history from X to B) or the work by the other person (history from X
       to A), you would need to first fetch the history from the repository, create a history that contains
       changes done by both parties, and push the result back.

       You can perform "git pull", resolve potential conflicts, and "git push" the result. A "git pull" will
       create a merge commit C between commits A and B.

                 B---C
                /   /
            ---X---A

       Updating A with the resulting merge commit will fast-forward and your push will be accepted.

       Alternatively, you can rebase your change between X and B on top of A, with "git pull --rebase", and push
       the result back. The rebase will create a new commit D that builds the change between X and B on top of A.

                 B   D
                /   /
            ---X---A

       Again, updating A with this commit will fast-forward and your push will be accepted.

       There is another common situation where you may encounter non-fast-forward rejection when you try to push,
       and it is possible even when you are pushing into a repository nobody else pushes into. After you push
       commit A yourself (in the first picture in this section), replace it with "git commit --amend" to produce
       commit B, and you try to push it out, because forgot that you have pushed A out already. In such a case,
       and only if you are certain that nobody in the meantime fetched your earlier commit A (and started building
       on top of it), you can run "git push --force" to overwrite it. In other words, "git push --force" is a
       method reserved for a case where you do mean to lose history.

EEXXAAMMPPLLEESS
       ggiitt ppuusshh
           Works like ggiitt ppuusshh <<rreemmoottee>>, where <remote> is the current branch’s remote (or oorriiggiinn, if no remote is
           configured for the current branch).

       ggiitt ppuusshh oorriiggiinn
           Without additional configuration, pushes the current branch to the configured upstream
           (bbrraanncchh..<<nnaammee>>..mmeerrggee configuration variable) if it has the same name as the current branch, and errors
           out without pushing otherwise.

           The default behavior of this command when no <refspec> is given can be configured by setting the ppuusshh
           option of the remote, or the ppuusshh..ddeeffaauulltt configuration variable.

           For example, to default to pushing only the current branch to oorriiggiinn use ggiitt ccoonnffiigg rreemmoottee..oorriiggiinn..ppuusshh
           HHEEAADD. Any valid <refspec> (like the ones in the examples below) can be configured as the default for
           ggiitt ppuusshh oorriiggiinn.

       ggiitt ppuusshh oorriiggiinn ::
           Push "matching" branches to oorriiggiinn. See <refspec> in the OPTIONS section above for a description of
           "matching" branches.

       ggiitt ppuusshh oorriiggiinn mmaasstteerr
           Find a ref that matches mmaasstteerr in the source repository (most likely, it would find rreeffss//hheeaaddss//mmaasstteerr),
           and update the same ref (e.g.  rreeffss//hheeaaddss//mmaasstteerr) in oorriiggiinn repository with it. If mmaasstteerr did not exist
           remotely, it would be created.

       ggiitt ppuusshh oorriiggiinn HHEEAADD
           A handy way to push the current branch to the same name on the remote.

       ggiitt ppuusshh mmootthheerrsshhiipp mmaasstteerr::ssaatteelllliittee//mmaasstteerr ddeevv::ssaatteelllliittee//ddeevv
           Use the source ref that matches mmaasstteerr (e.g.  rreeffss//hheeaaddss//mmaasstteerr) to update the ref that matches
           ssaatteelllliittee//mmaasstteerr (most probably rreeffss//rreemmootteess//ssaatteelllliittee//mmaasstteerr) in the mmootthheerrsshhiipp repository; do the
           same for ddeevv and ssaatteelllliittee//ddeevv.

           See the section describing <<rreeffssppeecc>>......  above for a discussion of the matching semantics.

           This is to emulate ggiitt ffeettcchh run on the mmootthheerrsshhiipp using ggiitt ppuusshh that is run in the opposite direction
           in order to integrate the work done on ssaatteelllliittee, and is often necessary when you can only make
           connection in one way (i.e. satellite can ssh into mothership but mothership cannot initiate connection
           to satellite because the latter is behind a firewall or does not run sshd).

           After running this ggiitt ppuusshh on the ssaatteelllliittee machine, you would ssh into the mmootthheerrsshhiipp and run ggiitt
           mmeerrggee there to complete the emulation of ggiitt ppuullll that were run on mmootthheerrsshhiipp to pull changes made on
           ssaatteelllliittee.

       ggiitt ppuusshh oorriiggiinn HHEEAADD::mmaasstteerr
           Push the current branch to the remote ref matching mmaasstteerr in the oorriiggiinn repository. This form is
           convenient to push the current branch without thinking about its local name.

       ggiitt ppuusshh oorriiggiinn mmaasstteerr::rreeffss//hheeaaddss//eexxppeerriimmeennttaall
           Create the branch eexxppeerriimmeennttaall in the oorriiggiinn repository by copying the current mmaasstteerr branch. This form
           is only needed to create a new branch or tag in the remote repository when the local name and the
           remote name are different; otherwise, the ref name on its own will work.

       ggiitt ppuusshh oorriiggiinn ::eexxppeerriimmeennttaall
           Find a ref that matches eexxppeerriimmeennttaall in the oorriiggiinn repository (e.g.  rreeffss//hheeaaddss//eexxppeerriimmeennttaall), and
           delete it.

       ggiitt ppuusshh oorriiggiinn ++ddeevv::mmaasstteerr
           Update the origin repository’s master branch with the dev branch, allowing non-fast-forward updates.
           TThhiiss ccaann lleeaavvee uunnrreeffeerreenncceedd ccoommmmiittss ddaanngglliinngg iinn tthhee oorriiggiinn rreeppoossiittoorryy..  Consider the following
           situation, where a fast-forward is not possible:

                           o---o---o---A---B  origin/master
                                    \
                                     X---Y---Z  dev

           The above command would change the origin repository to

                                     A---B  (unnamed branch)
                                    /
                           o---o---o---X---Y---Z  master

           Commits A and B would no longer belong to a branch with a symbolic name, and so would be unreachable.
           As such, these commits would be removed by a ggiitt ggcc command on the origin repository.

SSEECCUURRIITTYY
       The fetch and push protocols are not designed to prevent one side from stealing data from the other
       repository that was not intended to be shared. If you have private data that you need to protect from a
       malicious peer, your best option is to store it in another repository. This applies to both clients and
       servers. In particular, namespaces on a server are not effective for read access control; you should only
       grant read access to a namespace to clients that you would trust with read access to the entire repository.

       The known attack vectors are as follows:

        1. The victim sends "have" lines advertising the IDs of objects it has that are not explicitly intended to
           be shared but can be used to optimize the transfer if the peer also has them. The attacker chooses an
           object ID X to steal and sends a ref to X, but isn’t required to send the content of X because the
           victim already has it. Now the victim believes that the attacker has X, and it sends the content of X
           back to the attacker later. (This attack is most straightforward for a client to perform on a server,
           by creating a ref to X in the namespace the client has access to and then fetching it. The most likely
           way for a server to perform it on a client is to "merge" X into a public branch and hope that the user
           does additional work on this branch and pushes it back to the server without noticing the merge.)

        2. As in #1, the attacker chooses an object ID X to steal. The victim sends an object Y that the attacker
           already has, and the attacker falsely claims to have X and not Y, so the victim sends Y as a delta
           against X. The delta reveals regions of X that are similar to Y to the attacker.

GGIITT
       Part of the ggiitt(1) suite

Git 2.34.1                                          10/13/2022                                         GIT-PUSH(1)
