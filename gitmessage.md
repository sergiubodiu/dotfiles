# git commit messages

{TYPE}: [{SCOPE}] {SUBJECT} What?

{BODY} Why?

**{TYPE}**: Everybody can simply extract all types of changes in git log.

- [+] feature, test, fix
- [*] documentation, code-style, fix linter warning (no code change)
- [~] refactoring production code
- [!] breaking change (so pay attention)
- [!!!] security fix (so caution)

**{SCOPE}**: This is just the scope of the change, something like a namespace.

**{SUBJECT}**: Should use impertivite tone and say what you did.

**{BODY}**: The body should go into detail about why the changes are made.

## Time Tracking

Records time tracking information against an issue

    JIRA-12 #time <value>w <value>d <value>h <value>m
    example: JIRA-12 #time 2h 30m

## Comments

Adds a comment to a Jira Software issue.

    example: JRA-34 #comment This is a comment

Note: The committer's email address must match the email address of a single Jira Software user with permission to comment on issues in that particular project.

## Workflow transitions

Transitions a Jira Software issue to a particular workflow state.

    example: JRA-56 #close #comment Fixed this today

This example executes the close issue workflow transition for the issue and adds the comment 'Fixed this today' to the issue.

## References

- How to write a [good commit message](https://github.com/voku/dotfiles/wiki/git-commit-messages)
- More information on [smart commits](https://confluence.atlassian.com/bitbucket/use-smart-commits-298979931.html)
