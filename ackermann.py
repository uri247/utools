from sys import argv

mem = {}


def AA(m,n):
	assert m > 3
	if n==0:
		return A(m-1,1)
	else:
		return A(m-1,A(m,n-1))


def A(m,n):
	if m==0:
		return n+1
	elif m==1:
		return n+2
	elif m==2:
		return 2*n + 3
	elif m==3:
		return 2**(n+3) - 3

	if not (m,n) in mem:
		mem[(m,n)] = AA(m,n)
	return mem[(m,n)]




if __name__ == "__main__":
    m = int(argv[1])
    n = int(argv[2])
    print "calculating A({0},{1})".format( m, n )
    result = A(m, n)
    print result
    print 'A number with ', len(str(result)), ' digits'

