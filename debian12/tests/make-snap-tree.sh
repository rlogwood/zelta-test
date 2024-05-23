#!/bin/sh -x
SRCTOP='apool'
TGTTOP='bpool'
SRCTREE="$SRCTOP/treetop"
TGTTREE="$TGTTOP/treetop"

etch () {
	zfs list -Hro name -t filesystem $SRCTREE | tr '\n' '\0' | xargs -0 -I% -n1 \
		dd if=/dev/random of='/%/file' bs=64k count=1 > /dev/null 2>&1
	zfs list -Hro name -t volume $SRCTREE | tr '\n' '\0' | xargs -0 -I% -n1 \
		dd if=/dev/random of='/dev/zvol/%' bs=64k count=1 > /dev/null 2>&1
	zfs snapshot -r "$SRCTREE"@snap$1
}

zfs destroy -r "$SRCTREE"
zfs destroy -r "$TGTTOP"
zfs create -p $SRCTREE/'minus/two/one/0/lift off'
zfs create -p $SRCTREE/'minus/two/one/0/lift off'
zfs create -sV 16G -o volmode=dev $SRCTREE'/vol1'
#for num in `jot 2`; do
#	etch $num
#done

etch 1; etch 2; etch 3
zelta backup "$SRCTREE" "$TGTTREE"

# Test rotate
#zfs list -Hroname "$SRCTREE" | tr '\n' '\0' |xargs -t0I% zfs rollback -r %@snap2
#etch 4
#zelta sync "$SRCTREE" "$TGTTREE"
#exit 0

zfs create -p "$SRCTREE/add/7"
zfs snapshot "$SRCTREE/add/7"@src7
zfs create -u "$TGTTREE/sub"
zfs create -u "$TGTTREE/sub/8"
zfs snapshot "$TGTTREE/sub/8"@tgt8
zfs snapshot "$SRCTREE/minus/two/one/0"@src7
zfs snapshot "$TGTTREE/minus/two/one/0"@src7
zfs snapshot $SRCTREE'/vol1'@snap7
zfs destroy $SRCTREE'/vol1'@snap6
zelta match "$SRCTREE" "$TGTTREE" #2&>1 >match_output.txt
#etch 8
#zelta sync "$SRCTREE" "$TGTTREE"
#zelta match "$SRCTREE" "$TGTTREE"
