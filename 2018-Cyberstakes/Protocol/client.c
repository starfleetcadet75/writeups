#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

#define SERVER "127.0.0.1"
#define PORT 1234
#define BUFLEN 262

char buf[BUFLEN];
struct sockaddr_in addr;
int addrlen = sizeof(addr);
int seqnum = 0;

void hexdump(const void* data, size_t size) {
	char ascii[17];
	size_t i, j;
	ascii[16] = '\0';
	for (i = 0; i < size; ++i) {
		printf("%02X ", ((unsigned char*)data)[i]);
		if (((unsigned char*)data)[i] >= ' ' && ((unsigned char*)data)[i] <= '~') {
			ascii[i % 16] = ((unsigned char*)data)[i];
		} else {
			ascii[i % 16] = '.';
		}
		if ((i+1) % 8 == 0 || i+1 == size) {
			printf(" ");
			if ((i+1) % 16 == 0) {
				printf("|  %s \n", ascii);
			} else if (i+1 == size) {
				ascii[(i+1) % 16] = '\0';
				if ((i+1) % 16 <= 8) {
					printf(" ");
				}
				for (j = (i+1) % 16; j < 16; ++j) {
					printf("   ");
				}
				printf("|  %s \n", ascii);
			}
		}
	}
}

void process_packet(int sockfd) {
	seqnum++;

	memset(buf, 0, BUFLEN);
	if (recvfrom(sockfd, buf, BUFLEN, 0, (struct sockaddr*) &addr, &addrlen) < 0) {
		fprintf(stderr, "recvfrom() failed\n");
		exit(1);
	}

	// Decrypt the message
	uint8_t key = (uint8_t) rand();
	printf("%x", key);
	// for (int i = 0; i< 4; i++) {
		// printf("%c", buf[258 + i] ^ key);
	// }

	memset(buf, 0, BUFLEN);
	buf[1] = 4;
	buf[3] = seqnum;

	if (sendto(sockfd, buf, BUFLEN, 0, (struct sockaddr*) &addr, addrlen) < 0) {
		fprintf(stderr, "sendto() failed\n");
		exit(1);
	}
}

int main(int argc, char* argv[]) {
	memset(buf, 0, BUFLEN);
	srand(1);  // Call `srand()` with the same seed as the server

	int sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (sockfd < 0) {
		fprintf(stderr, "Failed to create socket\n");
		return 1;
	}

	memset((char*) &addr, 0, addrlen);
	addr.sin_family = AF_INET;
	addr.sin_port = htons(PORT);

	if (inet_aton(SERVER, &addr.sin_addr) == 0) {
		fprintf(stderr, "inet_aton() failed\n");
		return 1;
	}

	printf("Sending initial Request to Read (RRQ)\n");
	buf[1] = 1;
	sprintf(&buf[2], "%s", "flag");

	if (sendto(sockfd, buf, BUFLEN, 0, (struct sockaddr*) &addr, addrlen) < 0) {
		fprintf(stderr, "sendto() failed\n");
		exit(1);
	}

	if (recvfrom(sockfd, buf, BUFLEN, 0, (struct sockaddr*) &addr, &addrlen) < 0) {
		fprintf(stderr, "recvfrom() failed\n");
		exit(1);
	}

	while (seqnum < 9) {
		process_packet(sockfd);
	}

	close(sockfd);
	return 0;
}
