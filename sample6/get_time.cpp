
#include <sys/time.h>
#include <sys/resource.h>

extern "C" double get_time(void)
{
  static struct timeval tv;
  static struct timezone tz;
  gettimeofday(&tv, &tz);
  return ((double)(tv.tv_sec  + tv.tv_usec*1.0e-6));
}

