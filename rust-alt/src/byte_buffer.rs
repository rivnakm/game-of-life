#[cfg(target_pointer_width = "32")]
pub const USIZE_LEN: usize = 10;
#[cfg(target_pointer_width = "64")]
pub const USIZE_LEN: usize = 20;

pub struct ByteBuffer<const N: usize> {
    len: usize,
    buf: [u8; N],
}

impl<const N: usize> ByteBuffer<N> {
    #[inline(always)]
    pub const fn usize_to_ascii_bytes(mut num: usize) -> ByteBuffer<USIZE_LEN> {
        let mut buf = [0u8; USIZE_LEN];

        if num == 0 {
            buf[USIZE_LEN - 1] = b'0';
            return ByteBuffer { buf, len: 1 };
        }

        let mut rem = num % 10;
        let mut len = 0;
        while num != 0 {
            buf[USIZE_LEN - len - 1] = rem as u8 + b'0';
            num /= 10;
            rem = num % 10;
            len += 1;
        }

        ByteBuffer { buf, len }
    }

    #[inline(always)]
    pub const fn read(&self) -> &[u8] {
        unsafe { std::slice::from_raw_parts(self.buf.as_ptr().add(N - self.len), self.len) }
    }
}
